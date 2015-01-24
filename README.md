Reiki, called with `r`, is a shortcut for running rake tasks with arguments. No brackets, just spaces and commas (and colons to separate serial tasks). 

This is currently working wonderfully for me, but I'm open to pull requests and the project will develop further if my needs expand.

### Why?

I get a little crazy with my [Rakefiles](http://www.ruby-doc.org/core-1.9.3/doc/rake/rakefile_rdoc.html) in cases where it's my command central, such as my Jekyll blog or my app [Marked 2](http://marked2app.com) where I need to perform a wide variety of tasks with various arguments and sequences. Typing out task names with arguments in Rake's command line syntax can be tedious with square brackets, commas, quoted arguments, etc. I build Reiki for my own sanity.

I get that most people don't abuse Rakefiles to the extent that I do. You probably don't need this if you've never made a TextExpander shortcut to fill in tedious task names.

### Usage

Reiki uses fuzzy matching to figure out which task you want to run.

- If the first argument to `r` fully matches a rake task and there are no other potential matches, it runs it with any following arguments as arguments for that task (e.g. `r build true` becomes `rake build[true]`). 
- If there is more than one possible match, it checks to see if the second argument makes sense as `$1_$2`. If that's the case, it runs that with additional arguments. 
- If only the first letter(s) of a `$1_$2` task are provided, it guesses and checks before running (e.g. `r f d jekyll blogging` becomes `rake find_draft["jekyll blogging"]`).
- Additional arguments are assumed to be a quoted string unless there are commas, in which case it combines them and automatically quotes only resulting arguments with spaces in them (e.g. `r gd true, publishing jekyll blogging post` runs `rake gen_deploy[true,"publishing jekyll blogging post"]` on my blog, and the `gen_deploy` task takes an argument and a git commit message).

For example, in my Jekyll setup:

    r fdr jekyll
    => rake find_draft[jekyll]

    r fdf reiki bash
    => rake find_draft_fulltext["reiki bash"]

    r gen true, commit message
    => rake generate[true,"commit message"]

You can separate multiple (serial) tasks with a colon (:). Arguments after a task and before a colon are treated as arguments to each task. Multiple tasks are run by rake as a series.

    $ r bld xcode true: launch debug
    => rake build[xcode,true] launch[debug]

Reiki can automatically run the first match, or it can be set to verify with a question on the command line if there are multiple matches (or forced to always verify with the "quiet" option). A timeout can be set on the verification to automatically run if no response is provided.

If your Terminal supports color, output will be highlighted. If not, you'll get clean output with no escape sequences.

### Installation

Save the `reiki.plugin.bash` to disk and source it in your `.bash_profile`. 

    source ~/plugins/reiki.plugin.bash

When loaded, it will define the `r` command. Helpers are defined with `__r_` prefixes as a namespace.

If you use Bash-it, you can just drop it in your `~/.bash_it/plugins/enabled` folder.

### Configuration

You can configure defaults in the script (but see the next section to override them without modifying the original):

`verify_task=1` 
: to force a verification after guessing

`auto_timeout=X` 
: to change number of seconds to wait for verification, 0 to disable

`quiet=1` 
: to force silent mode, using first option if multiple matches are found

`debug=1` 
: for verbose reporting

#### Environment variables

Defaults can be overriden by environment variables in your login profile/rc:

	export R_VERIFY_TASK=true
	export R_AUTO_TIMEOUT=5
	export R_DEBUG=true
	export R_QUIET=true


### Options

You can override the default configuration using switches as needed. Use `r -T` to list options.

    $ r -H
    r: A shortcut for running rake tasks with fuzzy matching
    Parameters are task fragments and arguments, multiple arguments comma-separated

    Example:
        $ r gen dep commit message
        => rake generate_deploy[commit message]

    Options:

        -h      show options
        -H      show help
        -T      List available tasks
        -v      Interactively verify task matches before running
        -a SECONDS  Prompts run default result after SECONDS
        -q      Run quietly (use first match in case of multiples)
        -d      Output debug info

