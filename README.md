# Salon-Appointment-Scheduler

This repository contains a Bash script to manage a salon appointment system. The script interacts with a PostgreSQL database to allow customers to book services.

## Prerequisites

- PostgreSQL
- Bash

## Getting Started

1. **Clone the repository**:
    ```sh
    git clone https://github.com/yourusername/salon-appointment-system.git
    cd salon-appointment-system
    ```

2. **Set up the database**:
    - Ensure PostgreSQL is installed and running on your machine.
    - Create a database named `salon` and set up the necessary tables.
    
    ```sql
    CREATE DATABASE salon;

    \c salon

    CREATE TABLE services (
      service_id SERIAL PRIMARY KEY,
      name VARCHAR(50)
    );

    CREATE TABLE customers (
      customer_id SERIAL PRIMARY KEY,
      phone VARCHAR(20) UNIQUE,
      name VARCHAR(50)
    );

    CREATE TABLE appointments (
      appointment_id SERIAL PRIMARY KEY,
      customer_id INT REFERENCES customers(customer_id),
      service_id INT REFERENCES services(service_id),
      time VARCHAR(50)
    );
    ```

3. **Populate the database with sample data** (optional):
    ```sql
    INSERT INTO services(name) VALUES ('Haircut'), ('Manicure'), ('Pedicure'), ('Massage');
    ```

4. **Run the script**:
    ```sh
    ./salon.sh
    ```

## Script Functionality

### Main Menu
- **Displays available services**: Lists all services from the `services` table.
- **Prompts user for service selection**: Takes user input to select a service.
- **Handles invalid input**: Validates user input and prompts again for invalid entries.
- **Prompts user for phone number**: Checks if the user is already in the database or asks for their name if they are a new customer.
- **Schedules an appointment**: Takes the preferred appointment time and stores it in the `appointments` table.

## Script Structure

- **MAIN_MENU**: Displays the main menu and handles user input.
- **Service Selection**: Displays available services and validates user selection.
- **Customer Handling**: Checks if the customer is new or returning based on their phone number and updates the database accordingly.
- **Appointment Scheduling**: Takes the preferred time and records the appointment in the database.

