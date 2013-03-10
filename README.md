# Installation

Install:

	$ ./install.sh
	$ source ~/.venv/bash/venv.sh

Use:

	$ venv
	venv [create <name>]   - to create new virtualenv
	     [destroy <name>]  - to destroy chosen virtualenv
	     [use <name>]      - to activate chosen virtualenv
	     [exit]            - to deactivate current virtualenv
	     [ls]              - to list available virtualenvs

# Python

Similar usage to [/brianm/venv/](https://github.com/brianm/venv/).

# C/C++ and CMake

On activate venv creates alias:

```bash
	alias cmake="cmake -DCMAKE_INSTALL_PREFIX=${VIRTUAL_ENV} -DCMAKE_MODULE_PATH=${HOME}/.venv/cmake/"
```

Which tell cmake to install files and targets into virtualenv directory.

Also creates aliases:

```bash
	alias rpm_install="rpm --prefix=${VIRTUAL_ENV} --dbpath ${VIRTUAL_ENV}/db --nodeps -ivh"
	alias rpm_upgrade="rpm --prefix=${VIRTUAL_ENV} --dbpath ${VIRTUAL_ENV}/db --nodeps -Uvh"
	alias rpm_remove="rpm --dbpath ${VIRTUAL_ENV}/db -e"
```

# Files in ~/.venv/

Structure:

```
	~/.venv/
		venv/ <your-virtualenvs>
		bash/ <your-bash-scripts>
		cmake/ <yout-cmake-modules>
```

