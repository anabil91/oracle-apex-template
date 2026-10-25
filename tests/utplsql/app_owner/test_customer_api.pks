create or replace package test_customer_api
is
   --%suite(customer_api)
   --%suitepath(app_owner.customers)

   --%context(is_valid_email)

      --%test(accepts a well-formed address)
      procedure email_valid;

      --%test(rejects an address without @)
      procedure email_missing_at;

      --%test(rejects an address with spaces)
      procedure email_with_space;

   --%endcontext

   --%context(create_customer)

      --%test(inserts the customer and returns the new id)
      procedure create_returns_id;

      --%test(normalizes email to lower case and trims name)
      procedure create_normalizes_input;

      --%test(raises e_invalid_email for an invalid address)
      --%throws(customer_api.e_invalid_email)
      procedure create_invalid_email;

      --%test(raises dup_val_on_index for a duplicate email)
      --%throws(dup_val_on_index)
      procedure create_duplicate_email;

   --%endcontext

   --%context(deactivate_customer)

      --%test(sets status to INACTIVE)
      procedure deactivate_sets_status;

      --%test(raises no_data_found for an unknown id)
      --%throws(no_data_found)
      procedure deactivate_unknown;

   --%endcontext

end test_customer_api;
/
