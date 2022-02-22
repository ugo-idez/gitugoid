#!/bin/bash
HOST=sio@onfarbo41

usage() {
echo -e "Usage: $0 [-f] <compressed dumpfile>\n\t-f: force mode\n\t-h: this help\n" 1>&2; exit 1; }

restore() {
	zcat "${filename}" | ssh "${HOST}"  "mysql -u slam -pAzerty1+ bdarbre"
}

confirm() {
    read -r -n 1 -p "${1:-Confirmer?} [o/n]: " REPLY
    case "${REPLY}" in
      [oO]) echo ; restore ;;
      [nN]) echo ; exit 1 ;;
      *) printf " \033[31m %s \n\033[0m" "Entrée non valide"
    esac
}

while getopts "fh" OPT
do
    case "${OPT}" in
      f)
          forcemode=1
          ;;

      h)
	  usage
	  exit 0
          ;;
    esac
done
shift $((OPTIND-1))

filename="${1}"

if [[ -z "${filename}" ]] ; then
	usage
fi

if [[ ! -r "${filename}" ]] ; then
	echo "erreur ouverture fichier"
	exit 1
fi

if [[ "${forcemode}" == 1 ]]; then
	restore
	exit 0
else
	confirm
	exit 0
fi
exit 0
