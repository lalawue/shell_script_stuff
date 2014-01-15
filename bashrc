# by sucha in http://suchang.net
alias ls='ls -G'
export PATH=$PATH:~/bin
PS1='\h:\W \u\$ '
alias gentags='find . -name "*.[ch]" -print | etags - && find . -name "*.lua" -print | etags -a -'

checknew() {
	if [ $# == 2 ]; then
		diff -rqX ~/bin/diff_ignore.txt $1 $2
	else
		echo checknew DIR1 DIR2
	fi
}

copynew() {
	if [ $# != 2 ]; then
		echo copynew srcDir desDir
		return
	fi

	tmp_file=/tmp/ccc.txt

	# generate diff output
	diff -rqX ~/bin/diff_ignore.txt $1 $2 | grep "^Files" | cut -d" " -f 2,4 > $tmp_file

	#update file
	magic=12343188
	src=$magic
	for file in $(cat $tmp_file); do
		des=$file
		if [ $src == $magic ]; then
			src=$des
			continue
		elif [ -f $src ]; then
			echo cp $src $des
			cp $src $des
		fi
		src=$magic
	done

	rm $tmp_file
}

linesInFilePattern() {
	sum=0
	for file in $(find . -name "$1"); do
		line=`wc -l $file`
		cur=`echo $line | cut -d' ' -f1`
		sum=$(($sum + $cur))
	done
	echo total is $sum
}
