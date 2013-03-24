#!/bin/bash

# directory for virtualenvs
VENV_DIR="${HOME}/.venv/venv"

## Set variables and aliases for c/c++
function activate_cpp()
{
	mkdir -p ${VIRTUAL_ENV}/{include,lib,bin,ini,db}
	
	alias cmake="cmake -DCMAKE_INSTALL_PREFIX=${VIRTUAL_ENV} -DCMAKE_MODULE_PATH=${HOME}/.venv/cmake/"

	export LD_RUN_PATH="${VIRTUAL_ENV}/lib"
	export LD_LIBRARY_PATH="${LD_RUN_PATH}"

	alias rpm_install="rpm --prefix=${VIRTUAL_ENV} --dbpath ${VIRTUAL_ENV}/db --nodeps -ivh"
	alias rpm_upgrade="rpm --prefix=${VIRTUAL_ENV} --dbpath ${VIRTUAL_ENV}/db --nodeps -Uvh"
	alias rpm_remove="rpm --dbpath ${VIRTUAL_ENV}/db -e"
}

## Unset variables and aliases for c/c++
function deactivate_cpp()
{
	unalias cmake
	unalias rpm_install
	unalias rpm_upgrade
	unalias rpm_remove

	unset LD_RUN_PATH
	unset LD_LIBRARY_PATH
}

## Virtualenv prefix prompt
function __venv_prompt() 
{
	echo "[$(echo ${VIRTUAL_ENV} | cut -f5 -d/)] "
}

## Easy virtualenv management
function venv() 
{
	if test ! -d "${VENV_DIR}"
	then
		mkdir -p "${VENV_DIR}"
	fi

	local cmd="$1"
	local name="$2"
	shift 2

	case "${cmd}" in
		"create")
			# only if ${name} is not empty!
			if test -n "${name}"
			then
				virtualenv $@ --no-site-packages --distribute --prompt='$(__venv_prompt)'  "${VENV_DIR}/${name}"
				source "${VENV_DIR}/${name}/bin/activate"
				activate_cpp
				echo -e " >> \033[32;22musing virtualenv ${name}\033[0m <<"
			fi
			;;
		"destroy")
			# checking arguments...
			if test -z "${name}"
			then
				echo -e " !! \033[31;1minvalid arguments\033[0m !!"
			else
				# is it active virtualenv?
				if test "${VIRTUAL_ENV}" = "${VENV_DIR}/${name}"
				then
					# ... so we should deactivate ...
					deactivate_cpp
					deactivate
					echo -e " << \033[32;22mdeactivated virtualenv\033[0m >>"
				fi
				rm -rf "${VENV_DIR}/${name}"
				echo -e " << \033[32;22mdestroyed virtualenv\033[0m >>"
			fi
			;;
		"use")
			# checking arguments...
			if [ -r "${VENV_DIR}/${name}/bin/activate" ]
			then
				source "${VENV_DIR}/${name}/bin/activate"
				activate_cpp
				echo -e " >> \033[32;22musing virtualenv ${name}\033[0m <<"
			else
				echo -e " !! \033[31;1mnot found ${name}\033[0m !!"
			fi
			;;
		"exit")
			# am i in virtualenv?
			if test -n "${VIRTUAL_ENV}"
			then
				deactivate_cpp
				deactivate
				echo -e " << \033[32;22mdeactivated virtualenv\033[0m >>"
			else
				echo -e " !! \033[31;1mnot attached\033[0m !!"
			fi
			;;
		"ls")
			# just list directory
			ls "${VENV_DIR}"
			;;
		*)
			# little help
			echo "venv [create <name>]   - to create new virtualenv"
			echo "     [destroy <name>]  - to destroy chosen virtualenv"
			echo "     [use <name>]      - to activate chosen virtualenv" 
			echo "     [exit]            - to deactivate current virtualenv"
			echo "     [ls]              - to list available virtualenvs"
			;;
	esac
}

## Venv completition
function __venv_completion() 
{
    local cur prev opts
    local venvs="$(venv ls)"
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="create destroy use exit ls"

    case "${prev}" in
        destroy)
            COMPREPLY=( $(compgen -W "${venvs}" -- ${cur}) );;
        use)
            COMPREPLY=( $(compgen -W "${venvs}" -- ${cur}) );;
        *)
            COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) );;
    esac
}

complete -F __venv_completion venv

