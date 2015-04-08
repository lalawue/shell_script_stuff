#alias ls='ls -G'
export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacad
export MAGICK_HOME="$HOME/bin/ImageMagick-6.8.9"
export DYLD_LIBRARY_PATH="$MAGICK_HOME/lib/"
export GOROOT=$HOME/repos/go
export PATH=$PATH:$HOME/bin:$MAGICK_HOME/bin:$GOROOT/bin
export PS1='\h:\W \u\$ '
#
alias appBin="cd /Users/user/Library/Developer/Xcode/DerivedData/"
alias appData="cd '/Users/user/Library/Application Support/iPhone Simulator/7.1/Applications/'"
alias qkroot="cd '/Users/user/repos/github_lalawue/quick-cocos2d-x'"
alias gentags='find . -name "*.[ch]" -print | etags - && find . -name "*.lua" -print | etags -a -'
export svr_mac='00:16:d3:f7:cf:80'
export svr_ip='192.168.2.16'
export leon_ip='203.195.204.103'
alias cleanAppBin='cd /Users/user/Library/Developer/Xcode/DerivedData/cards-eebpuvnzpnjpuxbfpwfjvazubaiq/Build/Products/Debug-iphoneos/cards.app; rm -rf res scripts; cd -'

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

luajitCompileDir() {
	inDir=$PWD
	outDir=$HOME/Desktop/output
	pLen=$((${#inDir} + 1))
	param=$1
	if [ $# == 1 ]; then
		mkdir -p $outDir
		for dir in $(find . -type "d" -print); do
			d=$(basename $dir)
			if [ $d != "." ]; then
				mkdir -p $outDir/$d
			fi
		done
		for file in $(find . -name "*.lua" -print); do
			#cd '/Users/user/repos/LuaJIT-2.0.2/src/'
			dir=$(dirname $file)
			f=$(basename $file)
			if [ $dir != "." ]; then
				luajit $param $inDir/$dir/$f $outDir/$dir/$f
			else
				luajit $param $inDir/$f $outDir/$f
			fi
		done
	else
		#cd '/Users/user/repos/LuaJIT-2.0.2/src/'
		luajit -b
	fi
	cd $inDir
}
