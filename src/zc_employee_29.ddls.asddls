@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'EmployeeID' ]
@Metadata.allowExtensions: true
@Search.searchable: true
@EndUserText.label: 'Employee Consumption View'

define root view entity ZC_EMPLOYEE_29
provider contract transactional_query
as projection on ZI_EMPLOYEE_29
{
    key EmployeeUUID,
    EmployeeID,
    FirstName,
    LastName,
    Email,
    Phone,
    Department,
    JobTitle,
    HireDate,
    Status,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    LocalLastChangedAt
}
