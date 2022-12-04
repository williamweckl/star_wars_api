# Technical decision about separating Climantes and Terrains in entities instead of using the string field at the Planet

One of the first decisions I had to make when I was exploring the Star Wars public API was related to Climates and Terrains.

I've noticed that both climates and terrains are string fields at the public API but some records contained more than one climate or terrain inside that string, separated by commas.

This would make us repeat the data between every planet columns related to these fields, it would also more difficult to extract planets related to specific climates or terrains.

Even being more complex, I thought it would be a better approach to persist the climates and terrains as different entities, related to the planet.
