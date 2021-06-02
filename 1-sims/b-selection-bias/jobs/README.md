
# Selection simulation job files

Job files for running simulations on Blue Crystal phase 3.


## Useful commands


### Copy job files and change numbers for nc and ncs

```bash
cp ../jobs-10-10/j-10-10-corr0*.sh .
rename 10-10 10-50 *.sh
sed -i 's/-10-10-/-10-50-/g' *.sh
sed -i 's/10 10/10 50/g' *.sh
```
