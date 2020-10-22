# x86_64-elf-gcc-toolchain

## Usage

Using the compiler:

```sh
docker run --rm kevincharm/i686-elf-gcc-toolchain:5.5.0 bash -c 'x86_64-elf-gcc --version'
```

GRUB is also available in this image:

```sh
docker run --rm kevincharm/i686-elf-gcc-toolchain:5.5.0 bash -c 'grub-mkrescue --version'
```
