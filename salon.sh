#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU() {

  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  # print services we have
  READ_SERVICE=$($PSQL "SELECT * FROM services ORDER BY service_id")
  echo "$READ_SERVICE" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done 

  #take input from user, the service they want
  read SERVICE_ID_SELECTED

  #check user input is integer
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
    MAIN_MENU "Invalid Input: Please enter an integer"
    return
  fi

  #check entered service is available or not
  IS_SERVICE_CONTAIN=$($PSQL "SELECT service_id FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
  if [[ -z $IS_SERVICE_CONTAIN ]]
  then
    MAIN_MENU "I could not find that service. What would you like today?"
    return
  fi

  #if service available, then ask for phone number
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  #check is user already present in our database with phone number
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    CUSTOMER_INFO_ADD=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
  else
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  fi

  GET_SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
  echo -e "\nWhat time would you like your $GET_SERVICE_NAME, $CUSTOMER_NAME?"
  read SERVICE_TIME
  GET_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  APPOINTMENT_INFO_ADD=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES('$GET_CUSTOMER_ID','$SERVICE_ID_SELECTED','$SERVICE_TIME')")
  echo -e "\nI have put you down for a $GET_SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU
