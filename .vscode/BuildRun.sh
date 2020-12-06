cd ../Maui/build
#sudo rm -r *

cmake -DCMAKE_INSTALL_PREFIX=/usr .. && make && make install

cd ../../build/
cmake -DCMAKE_INSTALL_PREFIX=/usr .. && make && ./bin/index