# Creating a tree file for further use in [`TreeMineR()`](https://entjos.github.io/TreeMineR/reference/TreeMineR.md).

Creating a tree file for further use in
[`TreeMineR()`](https://entjos.github.io/TreeMineR/reference/TreeMineR.md).

## Usage

``` r
create_tree(x)
```

## Arguments

- x:

  A data frame that includes two or three columns:

  `node`

  :   A string defining a node

  `parent`

  :   A string defining the partent of the node

## Value

A data.frame with one variable `pathString` that describes the full path
for each leaf included in the hierarchical tree.
