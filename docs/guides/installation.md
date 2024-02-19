# Installation

Geniusrise is composed of the core framework and various plugins that implement specific tasks.
The core has to be installed first, and after that selected plugins can be installed as and when required.

## Installing Geniusrise

---

### Using pip

To install the core framework using pip in local env, simply run:

```bash
pip install geniusrise
```

Or if you wish to install at user level:

```bash
pip install generiusrise --user
```

Or on a global level (might conflict with your OS package manager):

```bash
sudo pip install geniusrise
```

To verify the installation, you can check whether the geniusrise binary exists in PATH:

```bash
which genius

genius --help
```
<!--
### Docker

Geniusrise containers are available on Docker hub.

```bash
docker run -it --rm geniusrise/geniusrise:latest
``` -->

## Installing Plugins

---

Geniusrise offers a variety of plugins that act as composable lego blocks. To install a specific plugin, use the following format:

```bash
pip install geniusrise-<plugin-name>
```

Replace `<plugin-name>` with the name of the desired plugin.

Available plugins are:

1. geniusrise-text: bolts for text models
2. geniusrise-vision: bolts for vision models
3. geniusrise-audio: bolts for audio models
4. geniusrise-openai: bolts for openai
5. geniusrise-listeners: spouts for streaming event listeners
6. geniusrise-databases: spouts for databases

Please visit [https://github.com/geniusrise](https://github.com/geniusrise) for a complete list of available plugins.

## Using Conda

1. Activate the environment:

```bash
conda activate your-env
```

2. Install Geniusrise:

```bash
pip install geniusrise
```

## Using Poetry

1. Add Geniusrise as a dependency:

```bash
poetry add geniusrise
```

For plugins:

```bash
poetry add geniusrise-<plugin-name>
```

## Development

---

For development, you may want to install from the repo:

```bash
git clone git@github.com:geniusrise/geniusrise.git
cd geniusrise
virtualenv venv -p `which python3.10`
source venv/bin/activate
pip install -r ./requirements.txt

make install # installs in your local venv directory
```

---

That's it! You've successfully installed Geniusrise and its plugins. 🎉

## Alternative Methods: TODO 😭

---

### Using package managers

Geniusrise is also available as native packages for some Linux distributions.

#### AUR

Geniusrise is available on the AUR for arch and derived distros.

```bash
yay -S geniusrise
```

or directly from git master:

```bash
yay -S geniusrise-git
```

#### PPA

Geniusrise is also available on the PPA for debian-based distros.

Coming soon 😢

#### Brew (cask)

Coming soon 😢

#### Nix

Coming soon 😢
