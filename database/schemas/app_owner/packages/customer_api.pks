create or replace package customer_api
   authid definer
is
   /**
    * Business API for CUSTOMERS. APEX pages call this package only;
    * no direct DML on the table from page processes.
    */

   e_invalid_email exception;
   pragma exception_init(e_invalid_email, -20001);

   function is_valid_email(
      pi_email in customers.email%type
   ) return boolean;

   function create_customer(
      pi_full_name in customers.full_name%type,
      pi_email     in customers.email%type
   ) return customers.customer_id%type;

   procedure deactivate_customer(
      pi_customer_id in customers.customer_id%type
   );

end customer_api;
/
