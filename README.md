This is a full reproduction of the memory leak described in this Github
issue. It should reproduce the problem "out of the box".

To reproduce it:

1. Run ```cabal configure``` and ```cabal install --dependencies only``` so you
  can build the project.

2. Execute the script ```reproduce-leak```, which runs the ```main``` method in
  Main.hs```. The first three examples should succeed: even though they allocate
  300 MB+ of memory, they deallocate it in time. The fourth will fail, which
  indicates that ```encodeUtf8``` holds either the ```ByteString``` or
  ```Text``` in memory than it needs to.
