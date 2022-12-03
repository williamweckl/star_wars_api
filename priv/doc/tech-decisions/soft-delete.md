# Technical decision about using Soft Delete approach

One of the requirements of the challenge is to a planet be able to being deleted by the use of an endpoint.

Deleting things from the database is always complicated because the data just disappear making it hard to understand what happened in the case of a problem that needs to be investigated.

The soft delete approach also allows a record to be restored in case of miss deleted.

For these reasons, I decided to use a soft delete approach.

All the entities have a field called `deleted_at` that is a datetime that is only filled when the record is deleted. If this field is filled, the record is not returned by the endpoints or queries.

## Trade off

By using this approach, the developers needs to always remember to add an aditional query condition when retrieving records from the database.

A common mistake could be to forget to add this aditional query condition.

Well documented projects and good code reviews can help to minimize this side effect. Also it needs to be part of the culture of the development team, if it is a team standard, it becomes more natural to the team developers.

For this challenge, I took the care to add this condition to every query.
