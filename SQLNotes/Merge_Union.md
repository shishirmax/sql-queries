**Diff between Merge and Union all in SSIS**
The Union All transformation combines multiple inputs into one output. The transformation inputs are added to the transformation output one after the other; no reordering of rows occurs.

The Merge transformation combines two sorted datasets into a single dataset. The rows from each dataset are inserted into the output based on values in their key columns.

The Merge transformation is similar to the Union All transformations. Use the Union All transformation instead of the Merge transformation in the following situations:

- The transformation inputs are not sorted.

- The combined output does not need to be sorted.

- The transformation has more than two inputs.

[Merge Transformation](https://docs.microsoft.com/en-us/sql/integration-services/data-flow/transformations/merge-transformation)