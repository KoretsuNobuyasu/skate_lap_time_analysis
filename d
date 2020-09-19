function d() {
  array=($(find ~/dev -type d | grep "$1" | grep -v ".git"))
  c=1
  
  for i in ${array[@]}
  do
    echo "$c: $i" | sed "s#$HOME#~#g"
    c=$((++c))
  done
  
  printf "\n"
  read -p "Which directory do you want to go?: " answer
  case "$answer" in
    [0-9]* )
      location=${array[$((answer-1))]}
      if [ -d $location ]; then
        cd "$location"
      else
        echo "$1 is not a directory."
      fi
      ;;
    * ) ;;
  esac
}
