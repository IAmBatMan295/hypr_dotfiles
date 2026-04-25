#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

PS1='\[\e[1;37m\]$(pwd | sed -e "s|^$HOME/||" -e "s|^$HOME$||")\[\e[0m\] '
alias bashrc='nvim ~/.bashrc'
alias zshrc='nvim ~/.zshrc'

cpg() {
  cd "$HOME/Desktop/cpg" || return
}
rustpg() {
  cd "$HOME/Desktop/rustpg" || return
}
pythonpg() {
  cd "$HOME/Desktop/pythonpg" || return
}

# Cmake
#
cmrun() {
  if [ -z "$1" ]; then
    echo "Usage: cmrun <executable-name>"
    return 1
  fi

  local target="./build/$1"

  if [ ! -x "$target" ]; then
    echo "Executable '$target' not found or not executable."
    return 1
  fi

  "$target"
}
cmakebuild() {
  if [ "$1" = "-i" ]; then
    echo "[cmakebuild] Mode: INDIVIDUAL"
    rm -rf build compile_commands.json
    cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DBUILD_MODE=INDIVIDUAL || return 1
    ln -sf build/compile_commands.json .
    cmake --build build || return 1

  elif [ "$1" = "-m" ]; then
    echo "[cmakebuild] Mode: MERGED"
    rm -rf build compile_commands.json
    cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DBUILD_MODE=MERGED || return 1
    ln -sf build/compile_commands.json .
    cmake --build build || return 1

  else
    echo "Usage: cmakebuild -i | -m"
    return 1
  fi
}

cmbuild() {
  cmake --build build
}

cmclean() {
  echo "[cmclean] Removing build/ and compile_commands.json"
  rm -rf build compile_commands.json
}

#Aliases

alias hconfig='nvim ~/.config/hypr/hyprland.conf'
alias wconfig='nvim ~/.config/waybar/config.jsonc'

alias mrsgain='rsgain easy -m MAX -p no_album -S "$HOME/Music/music"'
