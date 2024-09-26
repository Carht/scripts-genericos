#!/bin/bash

########################################################################
# Título: discover-with-os.sh
# Autor: Charte
# Requiere: nmap
# Categoría: Administración de sistemas
########################################################################
# Descripción
#    Nmap realiza un scan de las máquinas activas en la red
# a dichas máquinas se les extrae el sistema operativo.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>
#########################################################################

NAME=$(basename $0)
VER="0.1.0"

function usage() {
    echo >&2 "
${NAME} - Obtiene los host activos en un rango de red.
Version: ${VER}

uso: $NAME range

Ejemplo:

~> ${NAME} 192.168.0.1/24"
    exit 1
}

function checkroot() {
    if [[ $EUID -ne 0 ]]; then
	echo "Necesitas tener permiso de super usuario" 2>&1
	exit 1
    fi
}

function run-nmap() {
    RANGE=$1
    DISCOVER="nmap -O -v ${RANGE}"
    OUTPUT_FILE="host-descubiertos-nmap.txt"
    
    $DISCOVER > ${OUTPUT_FILE}
}

function read-nmap-file() {
    while IFS= read -r LINE; do
	IP_HOST=$(echo "$LINE" | grep -E "Nmap scan report for [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$")
	RUNNING_OS=$(echo "$LINE" | grep "Running: ")
	OS_DETAILS=$(echo "$LINE" | grep "OS details: ")
	SALIDA="${IP_HOST}${RUNNING_OS}${OS_DETAILS}"
	
	if [[ ${SALIDA} == "" ]];then
	    continue
	else
	    printf "${SALIDA}"
	    printf "\n"
	fi
    done < ${OUTPUT_FILE}
}

function clean-file() {
    rm "$OUTPUT_FILE"
}

case $1 in
    "")
	usage
	;;
    *)
	checkroot
	run-nmap "$1"
	read-nmap-file
	clean-file
	;;
esac
