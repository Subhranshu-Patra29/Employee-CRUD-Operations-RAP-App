# SAP RAP Employee CRUD Application

A sample employee management application built with the **SAP ABAP
RESTful Application Programming Model (RAP)**. It exposes employee data
through an **OData V4 service** and supports Create, Read, Update, and
Delete (CRUD) operations.

The project demonstrates a managed RAP business object, CDS view
entities, behavior definitions and implementations, server-side
validations, automatic employee ID generation, and service exposure.

## Features

-   **Create, Read, Update, and Delete** employee records through the
    OData service.
-   **Automatic Employee ID generation** in the `E0001`, `E0002`, ...
    format.
-   **Employee data validation**, including:
    -   Required first name and last name.
    -   Required and syntactically valid email address.
    -   Duplicate email and phone number checks.
    -   Phone number normalization and length validation (7--15 digits).
    -   Employee status restricted to `A` (Active) or `I` (Inactive).
    -   Valid calendar hire date; future hire dates are rejected.
    -   Employee ID uniqueness checks.
-   **RAP authorization handlers** for global create authorization and
    instance-level update/delete authorization.
-   **Managed fields** for creation and change tracking, including
    created by, created at, last changed by, and last changed at.

## Technology Stack

-   SAP ABAP
-   ABAP RESTful Application Programming Model (RAP)
-   ABAP CDS View Entities
-   Behavior Definitions and Behavior Implementations
-   OData V4
-   SAP Service Definition and Service Binding

## Application Architecture

The application is implemented using the following RAP objects:

  -----------------------------------------------------------------------
  Layer                   Object                  Purpose
  ----------------------- ----------------------- -----------------------
  Database table          `ZEMPLOYEE_29`          Stores employee master
                                                  data

  Interface CDS view      `ZI_EMPLOYEE_29`        Defines the root
                                                  interface view entity
                                                  over the database table

  Behavior definition     `ZI_EMPLOYEE_29`        Defines managed CRUD
                                                  behavior,
                                                  authorization,
                                                  validation, and
                                                  determination

  Behavior implementation `ZBP_I_EMPLOYEE_29`     Implements
                                                  authorization handlers,
                                                  employee ID generation,
                                                  and employee validation

  Projection CDS view     `ZC_EMPLOYEE_29`        Exposes the employee
                                                  fields for consumption

  Projection behavior     `ZC_EMPLOYEE_29`        Projects create,
                                                  update, and delete
                                                  operations

  Service definition      `ZAPI_EMPLOYEE_29`      Exposes the projection
                                                  as the `Employee`
                                                  entity

  Service binding         `ZAPI_EMPLOYEE_29_04`   Publishes the service
                                                  for OData consumption
  -----------------------------------------------------------------------

### Request flow

1.  A consumer sends an OData request to the published service.
2.  The service exposes the `ZC_EMPLOYEE_29` projection.
3.  The projection delegates supported operations to the interface
    behavior.
4.  The managed RAP runtime processes persistence and invokes the
    relevant custom handlers.
5.  The behavior implementation performs employee ID generation,
    authorization decisions, and validations as applicable.

## Employee Data Model

The `ZEMPLOYEE_29` table contains the following business fields:

  Field             Description
  ----------------- ---------------------------------
  `EMPLOYEE_UUID`   Employee UUID and technical key
  `EMPLOYEE_ID`     Generated employee identifier
  `FIRST_NAME`      Employee first name
  `LAST_NAME`       Employee last name
  `EMAIL`           Employee email address
  `PHONE`           Employee phone number
  `DEPARTMENT`      Employee department
  `JOB_TITLE`       Employee job title
  `HIRE_DATE`       Employee hire date
  `STATUS`          Employee status (`A` or `I`)

The table also includes client and RAP-managed audit fields:
`CREATED_BY`, `CREATED_AT`, `LAST_CHANGED_BY`, `LAST_CHANGED_AT`, and
`LOCAL_LAST_CHANGED_AT`.

## Validation Rules

Validation is implemented in the `validateEmployee` method and is
triggered on create and update.

  -----------------------------------------------------------------------
  Validation                          Rule
  ----------------------------------- -----------------------------------
  Employee ID                         Required and must be unique

  First name                          Required

  Last name                           Required

  Email                               Required; must match the expected
                                      email format; must be unique

  Phone                               Required; normalized to digits;
                                      must contain 7--15 digits; must be
                                      unique

  Status                              Must be `A` or `I`

  Hire date                           Must be a valid calendar date and
                                      cannot be in the future
  -----------------------------------------------------------------------

Email comparisons are performed without case sensitivity. Phone
comparisons ignore non-numeric formatting characters.

## Employee ID Generation

The `generateEmployeeID` determination runs on create. It reads the
highest existing employee ID with the `E` prefix and generates the next
four-digit sequence, for example:

-   `E0001`
-   `E0002`
-   `E0003`

The implementation supports IDs up to `E9999`.

## Authorization

The behavior definition declares instance authorization and requires
global authorization for create. The behavior implementation currently:

-   Allows create requests in `get_global_authorizations`.
-   Allows update and delete for each instance in
    `get_instance_authorizations`.

**Security note:** These handlers currently allow the operations for all
users who can access the service. They are suitable as demonstration
logic, not as a production authorization design. Add appropriate role-
or user-based checks before using this application in a production
environment.

## OData Service Operations

The service definition exposes the projection as the `Employee` entity.
The service binding publishes the service for OData V4 consumption.

  -----------------------------------------------------------------------
  HTTP method             Operation               Description
  ----------------------- ----------------------- -----------------------
  `POST`                  Create                  Creates a new employee.
                                                  The employee ID is
                                                  generated by the RAP
                                                  determination.

  `GET`                   Read                    Retrieves employee
                                                  records.

  `PATCH`                 Update                  Updates an existing
                                                  employee using its key.

  `DELETE`                Delete                  Deletes an existing
                                                  employee using its key.
  -----------------------------------------------------------------------

Use the service URL displayed by the activated service binding in ADT.
The exact endpoint and entity-key URL format depend on the SAP system
and service binding configuration.

### Example: Create an employee

Send a `POST` request to the `Employee` entity set with a payload such
as:

``` json
{
  "FirstName": "Alex",
  "LastName": "Morgan",
  "Email": "alex.morgan@example.com",
  "Phone": "9876543210",
  "Department": "Finance",
  "JobTitle": "Analyst",
  "HireDate": "2024-04-13",
  "Status": "A"
}
```

Do not provide `EmployeeUUID` or `EmployeeID` in the request; these are
generated/managed by the application.

A successful create response includes the generated employee ID and
RAP-managed audit fields. Use unique email and phone values when testing
because duplicates are rejected.

## Setup and Activation

Create or import the objects in an ABAP system that supports the ABAP
RESTful Application Programming Model.

Recommended object creation and activation sequence:

1.  Create database table `ZEMPLOYEE_29`.
2.  Create interface CDS view entity `ZI_EMPLOYEE_29`.
3.  Create the behavior definition for `ZI_EMPLOYEE_29`.
4.  Create behavior implementation class `ZBP_I_EMPLOYEE_29` and its
    local handler implementation.
5.  Create projection CDS view entity `ZC_EMPLOYEE_29`.
6.  Create projection behavior definition for `ZC_EMPLOYEE_29`.
7.  Create service definition `ZAPI_EMPLOYEE_29`.
8.  Create and publish service binding `ZAPI_EMPLOYEE_29_04`.

After activation, open the service binding in ADT, publish/activate it
as required by your system, and use its displayed service URL to test
the OData V4 endpoints. API requests can be tested with the available
service preview, an API client, or Swagger UI where configured.

## Repository Structure

The repository contains the ABAP object definitions and implementation
code, along with the documented build sequence and example OData
requests/responses.

Suggested organization when maintaining the repository:

``` text
SAP-RAP-Employee-CRUD/
├── README.md
├── src/
│   ├── database/
│   ├── cds/
│   ├── behavior/
│   └── service/
└── screenshots/
```

The structure above is a suggested organization for exported source
files; it does not imply that every folder is already present in the
repository.

## Testing

The documented API examples cover:

-   Creating an employee (`POST`)
-   Retrieving employees (`GET`)
-   Updating an employee (`PATCH`)
-   Deleting an employee (`DELETE`)

Also test validation scenarios, including missing required fields,
malformed email addresses, duplicate email/phone values, invalid status
values, invalid dates, and future hire dates.

## Notes and Limitations

-   The service binding's exact URL, protocol configuration, and
    authentication requirements are system-specific.
-   Authorization currently permits create, update, and delete
    operations; production deployments should implement proper access
    restrictions.
-   Employee ID generation uses a read-maximum-and-increment approach.
    For concurrent production workloads, consider a concurrency-safe
    number range or another collision-safe numbering strategy.
-   No frontend UI is included in the documented scope; the application
    is exposed as an OData API.

## License

No license is specified in this repository. Add a `LICENSE` file if you
intend to distribute or reuse the project under a particular open-source
license.
