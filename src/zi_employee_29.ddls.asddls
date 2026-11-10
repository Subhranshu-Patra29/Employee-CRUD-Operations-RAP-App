@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Employee Interface View'
@ObjectModel.semanticKey: [ 'EmployeeID' ]
@Metadata.allowExtensions: true
@Search.searchable: true

define root view entity ZI_EMPLOYEE_29 as select from zemployee_29
{
    key employee_uuid as EmployeeUUID,
    
    @Search.defaultSearchElement: true
      employee_id as EmployeeID,

      @Search.defaultSearchElement: true
      first_name as FirstName,

      @Search.defaultSearchElement: true
      last_name as LastName,

      @Search.defaultSearchElement: true
      email as Email,

      phone as Phone,

      @Search.defaultSearchElement: true
      department as Department,

      job_title as JobTitle,

      hire_date as HireDate,

      status as Status,

      @Semantics.user.createdBy: true
      created_by as CreatedBy,

      @Semantics.systemDateTime.createdAt: true
      created_at as CreatedAt,

      @Semantics.user.lastChangedBy: true
      last_changed_by as LastChangedBy,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at as LastChangedAt,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt
}
