TeaSafe: A user-space encrypted filesystem
------------------------------------------

##### What is it?

- an encrypted filesystem
- uses the FUSE headers and libraries 
- more like Truecrypt than EncFS
- uses the XTEA cipher for encryption
- employs a very simple and custom developed filesystem 
- can create and utilize a 'hidden' sub-volume
- might not be secure*
- probably buggy*
- in need of testers*

*That's where I need you to contribute! Please see below!

##### Slightly more wordy spiel..

The ongoing aim of TeaSafe is to learn about 
filesystem implementation -- the whole thing is based on ideas gleaned from various wiki 
articles about previously implemented filesystems (most prevalently HFS).
The filesystem is block-based, existing as a single 'disk image'
that can be mounted to a user-specified mount-point. In addition, the disk image 
is transformed using a variant of the XTEA algorithm to provide a measure of security.
TeaSafe also incorporates an experimental
'coffee mode' in which a 'sub-volume' can be specified at the time
of image creation. At the time of mounting, the user can choose to mount this
rather than the default root folder. This latter feature is inspired by truecrypt's 
'hidden partition' functionality and provides a small measure of obscurity.

### Security

The filesystem is encrypted using a varient of the XTEA algorithm. 
I don't consider myself an expert in encryption so I would invite you to
review my code before you consider it secure or not.
The more keen developer is encouraged to implement their own transformational cipher. All she 
needs to do is implement the function `doTransform` in `IByteTransformer` as defined in `IByteTransformer.hpp`.
See file `BasicByteTransformer.hpp` as an example of how this is done. The pointer type of `m_byteTransformer`
as initialized in the constructor argument list of `TeaSafeImageStream.cpp` then needs to be updated to
the developer's new implementation e.g.:

`m_byteTransformer(boost::make_shared<cipher::BasicByteTransformer>(io.password, io.iv, io.rounds))` --->
`m_byteTransformer(boost::make_shared<cipher::SomeOtherImplementation>(io.password, io.iv, io.rounds))`

Note that the parameters io.iv and io.rounds are XTEA cipher-specific. Yours may not require them.

An experimental 'coffee mode' is also supported which allows the user to specify
an additional sub-volume. Although multiple sub-volumes are possible, only two 
are currently supported (the default and the coffee mode version).

### Development requirements

All development was undertaken on a machine running osx10.9.
The development requirements are:

- Because of the use of strongly-typed enums, a c++11 compiler 
- a couple of boost libraries (system and filesystem) and the boost headers. Note, the makefile will need 
updating according to where boost is installed on your machine
- the latest version of osxfuse (I'm using 2.6.2). As with boost, you might need to update the makefile
(on linux, an implementation of FUSE should be part of the kernel already).

I envisage no problems running and compiling on linux. Windows unfortunately is a completely different beast
not least of which is due to a lack of a FUSE implementation.

### Compiling

`make` or `make all` will compile everything and all binaries. Please see above notes
on modifying the Makefile to point to correct library and header paths.

### Running

`./test` will run the test suite. This unit tests various parts of TeaSafe. As I uncover
new bugs and attempt to fix them, I will probably (but not always) add new units to verify the fixes.

`./maketeasafe image.tea 128000` will create a 500MB TeaSafe image from 128000 x 4096
byte blocks (note a block size of 4096 block size is hardcoded into DetailTeaSafe.hpp and represents
a good compromise between file speed and space efficiency). Example output:

<pre>
image path: test.tea
file system size in blocks: 128000
number of encryption rounds: 64
initialization vector: 1397590358
password:
</pre>

The password string will seed a SHA256 hash used to generate the
cipher stream. The cipher itself will use 64 rounds of encyption. This
is the default. To set a higher number of rounds, use the `--rounds` argument.
Note, a higher number of rounds results in slower, but more secure encryption thus
slower performance. Note however that internally, a cache is used to cache 
the first 250MB of the cipher stream. Up to this point performance, speed-wise, should be uniform
but will become slightly degraded once the number of file blocks is greater than
250MB worth.

`./maketeasafe image.tea 128000 --coffee 1` will create a 500MB TeaSafe image with
both a default root folder offset at block 0, and an extra sub-volume offset by a user-specified
block number value that must be less than the number of blocks (128000 in this example)
but greater than 0. Example output:

<pre>
image path: test.tea
file system size in blocks: 128000
number of encryption rounds: 64
initialiation vector: 1397590358
password:
sub-volume root block:
</pre>

The first 4 lines are general information about the image being created while
`password` and `sub-volume root block` are user prompts, the latter of which
is for when coffee mode was specified.

`./teasafe image.tea testMount` will launch and mount image.teasf under 
the directory testMount in fuse debug mode; note to disable debug
mode you need to specify `--debug 0` as an extra parameter. Disabling
debug mode will mount the image in single-threaded mode. Multi-threaded mode
is not currently supported.

If the image was initialized with a coffee sub-volume, then the image can be mounted
with the coffee parameter, which will alternatively mount the image's coffee 
(rather than default) sub-volume i.e.:

`./teasafe image.tea testMount --coffee 1`

This will ask the user to enter both the decryption password and the magic number.
When running the teasafe command, there is no need to specify the number of rounds originally used
by the encryption process as this is stored in the container header.

Licensing
---------

TeaSafe follows the BSD 3-Clause licence. 

Contributing
------------

Firstly, please use the google group TeaSafe for reporting feedback.

I am really in need of any feedback and testers and people who may like to
contribute. In particular, I need a UI that makes the whole image creation
and mounting process a little more user-friendly. Any takers?

If you do want to help out with the project -- awesome! --, you can use the 'forking' approach
as one suggested method. Basically, you'd do this:

1. Fork the repository
2. Clone the fork to your development machine
<pre>
git clone https://github.com/username/teasafe.git
</pre>
3. Configure your clone that that you get updates from the main repo:
<pre>
cd teasafe
git remote add upstream https://github.com/benhj/teasafe.git
git fetch upstream
</pre>
4. Rewrite your master branch so that any commits of yours that
aren't already in upstream/master are replayed on top of that
other branch:
<pre>
git rebase upstream/master
</pre>

If you want to edit files:

1. Edit files to make any changes and add/commit/push back to your branch
2. Send me a pull request so that I can merge the changes
 
More information here:
<pre>
https://help.github.com/articles/fork-a-repo
https://help.github.com/articles/using-pull-requests
</pre>

