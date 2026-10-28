create or replace package body customer_api
is

   function is_valid_email(
      pi_email in customers.email%type
   ) return boolean
   is
   begin
      return regexp_like(pi_email, '^[^@[:space:]]+@[^@[:space:]]+\.[^@[:space:]]+$');
   end is_valid_email;


   function create_customer(
      pi_full_name in customers.full_name%type,
      pi_email     in customers.email%type
   ) return customers.customer_id%type
   is
      l_customer_id customers.customer_id%type;
      l_email       customers.email%type := lower(trim(pi_email));
   begin
      if not is_valid_email(l_email) then
         raise_application_error(-20001, 'Invalid email address: ' || pi_email);
      end if;

      insert into customers (full_name, email)
      values (trim(pi_full_name), l_email)
      returning customer_id into l_customer_id;

      return l_customer_id;
   end create_customer;


   procedure deactivate_customer(
      pi_customer_id in customers.customer_id%type
   )
   is
   begin
      update customers
         set status = 'INACTIVE'
       where customer_id = pi_customer_id;

      if sql%rowcount = 0 then
         raise no_data_found;
      end if;
   end deactivate_customer;

end customer_api;
/
