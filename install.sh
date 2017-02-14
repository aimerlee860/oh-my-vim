main() {
  # Use colors, but only if connected to a terminal, and that terminal
  # supports them.
  if which tput >/dev/null 2>&1; then
      ncolors=$(tput colors)
  fi
  if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    BOLD="$(tput bold)"
    NORMAL="$(tput sgr0)"
  else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    NORMAL=""
  fi

  # Only enable exit-on-error after the non-critical colorization stuff,
  # which may fail on systems lacking tput or terminfo
  set -e

  CHECK_VIM_INSTALLED=$(whereis vim)
  if [ "X$CHECK_VIM_INSTALLED" == "X" ]; then
    printf "${YELLOW}Vim is not installed!${NORMAL} Please install vim first!\n"
    exit
  fi
  unset CHECK_VIM_INSTALLED

  if [ ! -n "$VIM" ]; then
    VIM=~/.oh-my-vim
  fi

  if [ -d "$VIM" ]; then
    printf "${YELLOW}You already have Oh My Vim installed.${NORMAL}\n"
    printf "You'll need to remove $VIM if you want to re-install.\n"
    exit
  fi

  # Prevent the cloned repository from having insecure permissions. Failing to do
  # so causes compinit() calls to fail with "command not found: compdef" errors
  # for users with insecure umasks (e.g., "002", allowing group writability). Note
  # that this will be ignored under Cygwin by default, as Windows ACLs take
  # precedence over umasks except for filesystems mounted with option "noacl".
  umask g-w,o-w

  printf "${BLUE}Cloning Oh My Vim...${NORMAL}\n"
  hash git >/dev/null 2>&1 || {
    echo "Error: git is not installed"
    exit 1
  }
  # The Windows (MSYS) Git is not compatible with normal use on cygwin
  if [ "$OSTYPE" = cygwin ]; then
    if git --version | grep msysgit > /dev/null; then
      echo "Error: Windows/MSYS Git is not supported on Cygwin"
      echo "Error: Make sure the Cygwin git package is installed and is first on the path"
      exit 1
    fi
  fi
  env git clone --depth=1 https://github.com/aimerlee860/on-my-vim.git $VIM || {
    printf "Error: git clone of oh-my-vim repo failed\n"
    exit 1
  }


  printf "${BLUE}Looking for an existing vim config...${NORMAL}\n"
  if [ -f ~/.vimrc ] || [ -h ~/.vimrc ]; then
    printf "${YELLOW}Found ~/.vimrc.${NORMAL} ${GREEN}Backing up to ~/.vimrc.pre-oh-my-vim${NORMAL}\n";
    mv ~/.vimrc ~/.vimrc.pre-oh-my-vim;
  fi

  printf "${BLUE}Using the Oh My Vim template file and adding it to ~/.vimrc${NORMAL}\n"
  ln -sf $VIM/vimrc ~/.vimrc
  ln -sf $VIM/vim ~/.vim

  printf "${GREEN}"
  echo '         __                        __      _ _ _   _    '
  echo '  ____  / /_     ____ ___  __  __  \ \    /// / | / \   '  
  echo ' / __ \/ __ \   / __ `__ \/ / / /   \ \  /// / ||/   \  '
  echo '/ /_/ / / / /  / / / / / / /_/ /     \ \/// / /|/ /\  \ '
  echo '\____/_/ /_/  /_/ /_/ /_/\__, /       \_//_//_//_/  \__\'
  echo '                        /____/                          ....is now installed!'
  echo ''
  echo ''
  echo 'Please look over the ~/.vimrc file to select plugins, themes, and options.'
  echo ''
  echo 'p.s. Follow us at aimerlee860@gmail.com.'
  echo ''
  echo ''
  printf "${NORMAL}"
}

main
