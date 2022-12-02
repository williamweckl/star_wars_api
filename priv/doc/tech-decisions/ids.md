# Technical decisions about entities IDs

For this project, I used decisions inspired by Domain Driven Design and Clean Architecture methodologies.

These approaches always take into account a business vision instead a technical one.

It is easy to make a decision of IDs and other attributes thinking just about technical aspects, but what if business reports and business people that looks at the data needs something more legible than something generated automatically?

I usually prefer the use of some approaches, depending on the entity itself and what the business areas expects from these entities.

Since I cannot talk with the business people about to understand a little more (approach that I would take when solving a real problem), I made those decisions for the challenge.

## String IDs

I usually prefer to use String IDs when the entity table has just a few records (< 100 for example) and it could / needs to be something legible. When business people uses a name reference instead of a number or code to talk about the entity. 

When some other entity is related to the one that has string IDs we usually don't need to look for another entity to understand the hole picture.

In the case of this challenge, this decision was made for the entities **Climate** and **Terrain**. With that decision, the entity **Planet** can benefit for a complete understanding by don't having to look at the Climate and Terrain entities.

This decision makes that the entity reference (ID) is something more legible than something automatically generated.

## Automatically generated IDs

I use this approach when there is an expectation that the entity table grows and when the business people does not care about the reference IDs.

In those cases I would prefer to have something more secure than an auto incremented integer because some attacker could guess the next ID in case of some security breach - like for example a SQL injection.

When the business cares about the ID, like for example a Customer of ID 1234, I would create another column to be this reference, keeping the primary key more secure or an approach to generate a more legible ID like for example the youtube videos IDs.

Automatically generated IDs was the approach used for the **Planet** entity, understanding that it could grow and maybe the business people does not care about having a legible reference.
