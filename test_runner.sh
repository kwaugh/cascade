#! /bin/bash
# NOTE: run this script as sudo
# Things to change when switching test repos:
# 1. The commit address
# 2. The loop iterations
# 3. The project directory and the project main test file
rm output.txt
for i in `seq 1 32`
do
    export ps_lines=$(ps aux | grep bin/quartus_server | wc -l)
    while [ $ps_lines -le 1 ]
    do
        bin/quartus_server --virtualize_fpga >> output.txt &
        sleep 1
        export ps_lines=$(ps aux | grep bin/quartus_server | wc -l)
    done
	cd evaluation/VerilogAES
	sudo ../../bin/cascade --march de10_jit -e debug.v
	# sudo bin/cascade --march de10_jit -e test/cache/pad.v
	cd ../..
	export hits=$(grep -o 'HIT' output.txt | wc -l)
	export misses=$(grep -o 'MISS' output.txt | wc -l)
	export commit=$(git log --pretty=format:'%h' -n 1)
	echo "$hits HITS, $misses MISSES on commit $commit"
    killall quartus_server

	# move forward one commit
	cd evaluation/VerilogAES
	git checkout $(git rev-list --topo-order HEAD..8d841cee72f7eb60779e6d5e29ea55cd1e007a7f | tail -1)
	cd ../..
done
