# My seL4 playground

Code, instructions, configuration, etc. for writing [seL4](https://sel4.systems/) and [CAmkES](https://docs.sel4.systems/projects/camkes/) applications.

Instructions are certainly unclear, so if you're trying to follow along and have questions, post an issue or email me.

## Setting up

Download dependencies

1. Install the [repo](https://source.android.com/setup/develop#installing-repo) tool.
2. Download source repositories.

```bash
git clone https://source.denx.de/u-boot/u-boot.git
mkdir camkes-project
pushd camkes-project
repo init -u https://github.com/seL4/camkes-manifest.git
repo sync
popd
mkdir sel4test
pushd sel4test
repo init -u https://github.com/seL4/sel4test-manifest.git
repo sync
popd
```

3. We build most of the binaries and other artifacts in a Docker image. Build the Docker image.

```bash
docker build -t sel4-playground-builder .
```

4. See device-specific instructions in `devices/` directory for further instructions.
