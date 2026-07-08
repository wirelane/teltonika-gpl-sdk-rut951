#!/bin/sh
# Upload file to FTP server

. /lib/functions.sh

APP_NAME="ftp_upload.sh"
WORK_DIR="/var/run/ulogd"
LOG_FILE="${WORK_DIR}/ftp_log"
LOGGER="logger -t $APP_NAME -s"
CLIENT=$(which ftpput)


config_load ulogd
config_get host ftp host
config_get dname ftp dname "traffic_log.tar.gz"
config_get username ftp username
config_get password ftp password
config_get port ftp port 21
config_get debug ftp debug
config_get delay ftp delay 6
config_get extra_name_info ftp extra_name_info
config_get custom_string ftp custom_string
config_get remote_file_path ftp remote_file_path
config_get protocol ftp protocol "ftp"
config_get key_auth ftp key_auth
config_get strict_key_checking ftp strict_key_checking
config_get server_public_key ftp server_public_key
config_get cafile ftp cafile
config_get certfile ftp certfile
config_get keyfile ftp keyfile
config_get insecure ftp insecure
config_get use_tpm ftp use_tpm
config_get privkey ftp privkey

config_get sname ftp sname
[ -z "$sname" ] && config_get sname emu1 file "/var/run/ulogd/ulogd_wifi.log"

archive_file(){
	tar -czf "${WORK_DIR}/${2}" "$1"
	rotate_log $1
}

#Clean and reopen ulogd log file
rotate_log(){
	> $1
	#/bin/killall -HUP ulogd 2> /dev/null
}

[[ -z "$CLIENT" ]] && {
	$LOGGER "FTP client not found"
	exit 1
}

[[ -z "$host" ]] && {
	$LOGGER "No FTP host provided."
	exit 1
}

case "$extra_name_info" in
	mac)
		EXTRA=$(mnf_info --mac)
	;;
	serial)
		EXTRA=$(mnf_info --sn)
	;;
	custom)
		[[ -n "$custom_string" ]] && EXTRA="$custom_string"
	;;
esac

prefix=$(date +20%y%m%d_%H%M%S)
DEST_NAME="${prefix}${EXTRA:+_$EXTRA}_${dname}"
DEST_FILE="${WORK_DIR}/${DEST_NAME}"

archive_file "$sname" "$DEST_NAME"

[ -n "$remote_file_path" ] && DEST_NAME="${remote_file_path}${DEST_NAME}"

case "$protocol" in
	sftp)
		[ "$strict_key_checking" = "1" ] && [ -n "$server_public_key" ] && {
			mkdir -p "$WORK_DIR/.ssh"
			echo "$server_public_key" > "$WORK_DIR/.ssh/known_hosts"
		}
		[ -n "$password" ] && export DROPBEAR_PASSWORD="$password"
		;;
	ftps)
		[ "$use_tpm" = "1" ] && [ -n "$keyfile" ] &&
			keyfile="handle:$(tpm2_importer "$keyfile" get_handle)"
		;;
	ftp|*)
		;;
esac

for i in 1 2 3 4 5
do
	case "$protocol" in
		sftp)
			HOME="$WORK_DIR" scp $([ "$key_auth" = "1" ] && echo "-i $privkey") ${port:+-P "$port"} ${debug:+-v} \
				-o StrictHostKeyChecking=$([ "$strict_key_checking" = "1" ] && echo "yes" || echo "no") \
				"$DEST_FILE" "$username@$host:$DEST_NAME" &> $LOG_FILE
			;;
		ftps)
			# OPENSSL_CONF is needed for tpm2 to work properly
			OPENSSL_CONF=/dev/null curl ${username:+${password:+-u "$username:$password"}} \
				${debug:+-v} --ssl-reqd --ftp-create-dirs \
				$([ "$insecure" = "1" ] && echo --insecure) \
				$([ -n "$cafile" ] && echo --cacert "$cafile") \
				$([ -n "$certfile" ] && [ -n "$keyfile" ] && echo --cert "$certfile" --key "$keyfile") \
				$([ "$use_tpm" = "1" ] && echo --engine tpm2 --key-type PROV) \
				-T "$DEST_FILE" "ftp://${host}${port:+:$port}/${DEST_NAME}" &> $LOG_FILE
			;;
		ftp|*)
			ftpput ${username:+-u "$username"} ${password:+-p "$password"} ${port:+-P "$port"} \
				${debug:+ -v} "$host" "$DEST_NAME" "$DEST_FILE" &> $LOG_FILE
			;;
	esac

	if [ "$?" -ne "0" ]; then
		cat "$LOG_FILE" | $LOGGER
		sleep $delay
	else
		$LOGGER "FTP upload successful."
		break
	fi
done

unset DROPBEAR_PASSWORD
rm -rf "$DEST_FILE"