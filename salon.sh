#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon -t -c "

echo -e "\n~~~~ MY SALON ~~~~~\n"
MAIN_MENU(){
  if [[ $1 ]] 
  then
  echo -e "\n$1"
  else
  echo -e "Welcome to My Salon, how can I help you?\n"
  fi
echo -e "1) cut\n2) color\n3) perm\n4) style\n5) trim"
read SERVICE_ID_SELECTED

case $SERVICE_ID_SELECTED in
1) QUERY_MODE ;;
2) QUERY_MODE ;;
3) QUERY_MODE ;;
4) QUERY_MODE ;;
5) QUERY_MODE ;;
*) MAIN_MENU "I could not find that service. What would you like today?" ;;
esac
}
QUERY_MODE(){
#which service
OPTION=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;")

#ask for phone number
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE

CHECK_PHONE=$($PSQL "SELECT phone FROM customers WHERE phone = '$CUSTOMER_PHONE';")

#if phone does not exist
if [[ -z $CHECK_PHONE ]]
then
echo -e "\nI don't have a record for that phone number, what's your name?"
read CUSTOMER_NAME

#insert to customers
INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME');")
fi

#get customer name and id if phone exist
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE';")
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")

#ask for time
echo -e "\nWhat time would you like your$OPTION,$CUSTOMER_NAME?"
read SERVICE_TIME

#input appointment
INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME');")

#final output
echo -e "\nI have put you down for a$OPTION at $SERVICE_TIME,$CUSTOMER_NAME."
}
MAIN_MENU