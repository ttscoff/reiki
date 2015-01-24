# Completion function for `r` (http://brettterpstra.com/projects/reiki)
# Still experimental

__r_bash_complete() {
	toplevel=$PWD

	if [ ! -f Rakefile ]; then
		toplevel=$(git rev-parse --show-toplevel 2> /dev/null)
		if [ -z $toplevel || ! -f $toplevel/Rakefile ]; then
			return 1
		fi
	fi
    if [ -f $toplevel/Rakefile ]; then
        recent=`ls -t $toplevel/.r_completions~ $toplevel/Rakefile $toplevel/**/*.rake 2> /dev/null | head -n 1`
        if [[ $recent != '.r_completions~' ]]; then
            ruby -rrake -e "Rake::load_rakefile('$toplevel/Rakefile'); puts Rake::Task.tasks" > .r_completions~
        fi

        COMPREPLY=($(compgen -W "`sort -u .r_completions~`" -- ${COMP_WORDS[COMP_CWORD]}))
        return 0
    fi
}

complete -o default -F __r_bash_complete r
