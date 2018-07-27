# Check for interactive bash and that we haven't already been sourced.
[ -z "$BASH_VERSION" -o -z "$PS1" -o -n "$BASH_COMPLETION" -o -n "$SDK_BASH_COMPLETION" ] && return

export SDK_BASH_COMPLETION="yes"

# source the bash completion scripts
BASH_COMP_DIR=/etc/bash_completion.d

if [ -d $BASH_COMP_DIR ]; then
   for i in $(ls $BASH_COMP_DIR/*);
   do
        . "$i"
   done
fi