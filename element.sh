#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"


if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$1")
    echo $NAME
  fi


  if [[ $1 =~ ^[A-Z][a-z]?$ ]]
  then
    NAME=$($PSQL "SELECT name FROM elements WHERE symbol=$1")
    echo $NAME
  fi

fi