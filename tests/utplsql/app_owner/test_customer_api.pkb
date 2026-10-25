create or replace package body test_customer_api
is

   procedure email_valid
   is
   begin
      ut.expect(customer_api.is_valid_email('jane.doe@example.com')).to_be_true();
   end email_valid;


   procedure email_missing_at
   is
   begin
      ut.expect(customer_api.is_valid_email('jane.doe.example.com')).to_be_false();
   end email_missing_at;


   procedure email_with_space
   is
   begin
      ut.expect(customer_api.is_valid_email('jane doe@example.com')).to_be_false();
   end email_with_space;


   procedure create_returns_id
   is
      l_id    customers.customer_id%type;
      l_count pls_integer;
   begin
      l_id := customer_api.create_customer('Jane Doe', 'ut.create@example.com');

      select count(*) into l_count from customers where customer_id = l_id;

      ut.expect(l_id).not_to_be_null();
      ut.expect(l_count).to_equal(1);
   end create_returns_id;


   procedure create_normalizes_input
   is
      l_id  customers.customer_id%type;
      l_row customers%rowtype;
   begin
      l_id := customer_api.create_customer('  Jane Doe  ', '  UT.Norm@Example.COM ');

      select * into l_row from customers where customer_id = l_id;

      ut.expect(l_row.full_name).to_equal('Jane Doe');
      ut.expect(l_row.email).to_equal('ut.norm@example.com');
      ut.expect(l_row.status).to_equal('ACTIVE');
   end create_normalizes_input;


   procedure create_invalid_email
   is
      l_id customers.customer_id%type;
   begin
      l_id := customer_api.create_customer('Jane Doe', 'not-an-email');
   end create_invalid_email;


   procedure create_duplicate_email
   is
      l_id customers.customer_id%type;
   begin
      l_id := customer_api.create_customer('Jane Doe', 'ut.dup@example.com');
      l_id := customer_api.create_customer('John Doe', 'ut.dup@example.com');
   end create_duplicate_email;


   procedure deactivate_sets_status
   is
      l_id     customers.customer_id%type;
      l_status customers.status%type;
   begin
      l_id := customer_api.create_customer('Jane Doe', 'ut.deact@example.com');

      customer_api.deactivate_customer(l_id);

      select status into l_status from customers where customer_id = l_id;
      ut.expect(l_status).to_equal('INACTIVE');
   end deactivate_sets_status;


   procedure deactivate_unknown
   is
   begin
      customer_api.deactivate_customer(-1);
   end deactivate_unknown;

end test_customer_api;
/
