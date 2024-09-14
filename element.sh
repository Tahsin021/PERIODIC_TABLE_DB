#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # Check if the argument is an atomic number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    CONDITION="atomic_number=$1"
  # Check if the argument is a symbol
  elif [[ $1 =~ ^[A-Z][a-z]?$ ]]
  then
    CONDITION="symbol='$1'"
  # Check if the argument is an element name
  elif [[ $1 =~ ^[A-Za-z]+$ ]]
  then
    CONDITION="name='$1'"
  else
    echo "I could not find that element in the database."
    exit
  fi

  # Get element details
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol FROM elements WHERE $CONDITION")
  
  # Check if element was found
  if [[ -z $ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    # Parse the retrieved element data
    IFS=" | " read ATOMIC_NUMBER NAME SYMBOL <<< $(echo $ELEMENT | xargs)
    
    # Get other properties from the database
    TYPE=$($PSQL "SELECT type FROM types RIGHT JOIN properties USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER" | xargs)
    MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER" | xargs)
    MP=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER" | xargs)
    BP=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER" | xargs)

    # Display the element information
    echo -e "\nThe element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
  fi
fi