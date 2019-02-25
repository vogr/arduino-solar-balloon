
## Compile
To compile `ballon-solaire`, run `nix-build -A ballon-solaire` (or `make`).

## Deploy
```
make deploy
```

 ### Why use an intermediary script:

> Now we need to write a script that would publish this package to NPM. Our first instinct is to put our script into a derivation. But should we? Actually not, for the following reasons:

> *  A publishing script is going to make use of secret keys we don't want leaking into /nix/store.
> *  A publishing script really cannot be thought of as a pure function. It doesn't always produce an output, and it is often necessary to rerun the same script with the same inputs, in which case Nix, with its pure-function assumption, will hit the cache (/nix/store) instead.

( ~ <http://www.boronine.com/2018/02/02/Nix/>)

## Libraries
To add a library, write `libs/<library>/default.nix` and callPackage it from `default.nix`, and add it to the `inherit ...` expression.
You can then add it to the dependancies in `build.nix` and add a line `-libraries ${libary}` to the build command.

WARNING: Arduino library MUST be in a subfolder e.g. for Directio it will be `/nix/xxx-xxx-directio/DirectIO/DirectIO.h`.

## Debug
To debug the compilation process :
```
make debug
```
Run the build process with `genericBuild`, or only run some phases.

To test the libraries, use nix-build:

```
nix-build . -A directio
```

## File hierarchy
* `build.nix` nix expression describing how to build blink.
* `default.nix` list of derivations, each derivation can be built with `nix-build -A snip`.
* `shell.nix` opened when `nix-shell` is called.
