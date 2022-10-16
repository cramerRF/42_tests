F_ALL=0
F_TRI=0
F_UNI=0
F_WAR=0

UNI_REPO=https://github.com/alelievr/libft-unit-test
TRI_REPO=https://github.com/Tripouille/libftTester
WAR_REPO=https://github.com/y3ll0w42/libft-war-machine.git

while getopts 'hatwur:' flag
do
	case "${flag}" in
		a) F_ALL="1";;
		t) F_TRI="1";;
		w) F_WAR="1";;
		u) F_UNI="1";;
		r) F_REPO="$OPTARG";;
		h)
			echo "help"
			echo "Usage flags:"
			echo "	-r your_repo"
			echo "	-a all tests"
			echo "	-w war test"
			echo "	-u uni test"
			echo "	-t tri test"
			exit
			;;
	esac
done

rm -rf tester_libft results
mkdir tester_libft results
cd tester_libft
git clone $F_REPO libft
if [[ $? != 0 ]]
then
	exit
fi

if [[ $F_ALL == 1 ]]
then
	F_TRI=1
	F_UNI=1
	F_WAR=1
fi
if [[ $F_WAR == 1 ]]
then
	echo "################### TEST WAR ###################"
	cd libft
	for f in ft_lst*; do mv $f "${f/_bonus.c/.c}"; done
	git clone $WAR_REPO war_tester
	cd war_tester
	./grademe.sh
	./grademe.sh > ../../../results/war.log
	
	cp deepthought ../../../results/deep_war.log
	cd ..
	for f in ft_lst*; do mv $f "${f/.c/_bonus.c}"; done
	rm -rf war_tester
	cd ..
fi
if [[ $F_UNI == 1 ]]
then
	echo "################### TEST UNI ###################"
	git clone $UNI_REPO uni_tester
	cd uni_tester
	make f > ../../results/uni.log
	cp result.log ../../results/result_uni.log
	cd ..
	rm -rf uni_tester
fi
if [[ $F_TRI == 1 ]]
then
	echo "################### TEST TRI ###################"
	cd libft
	git clone $TRI_REPO tri_tester
	cd tri_tester
	make a > ../../../results/tri.log
	cd ../..
	rm -rf libft/tri_libft
fi
echo "################### ALL DONE ###################"
