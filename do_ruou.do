use "C:\Users\Windows\Downloads\Báo cáo kinh tế lượng_Nhóm 1\Báo cáo kinh tế lượng_Nhóm 1\wine_dataset.dta"
encode country, generate(country_num)
drop if price > 3000 
gen lprice = ln(price)   
gen lrating = ln(rating) 
gen lnumber = ln(number)
gen lage = ln(age)
gen t = _n
tsset t
set cformat %9.4f
display "--- THONG KE BIEN GOC ---"
summarize price rating number age
display "--- THONG KE BIEN LOGARIT ---"
summarize lprice lrating lnumber lage
display "========== MO HINH 1: LIN - LIN =========="
regress price rating number age i.country_num
vif
estat ovtest
estat hettest
test number
ovtest,rhs
predict resid1, residuals
sktest resid1
swilk resid1
estat dwatson
estat durbin 
est store model1
display "========== MO HINH 2: LOG - LIN =========="
regress lprice rating number age i.country_num
vif
estat ovtest
estat hettest
ovtest,rhs
predict resid2, residuals
sktest resid2
swilk resid2
estat dwatson
estat durbin
estat bgodfrey,lag(1/5) 
est store model2
display "========== MO HINH 3: LOG - LOG =========="
regress lprice lrating lnumber lage i.country_num
vif
estat ovtest
estat hettest
ovtest,rhs
predict resid3, residuals
sktest resid3
swilk resid3
estat dwatson
estat durbin 
estat bgodfrey,lag(1/5) 
est store model3
display "========== MO HINH 4: LIN - LOG =========="
regress price lrating lnumber lage i.country_num
vif
test lnumber
estat ovtest
estat hettest
ovtest,rhs
predict resid4, residuals
sktest resid4
swilk resid4
estat dwatson
estat durbin 
estat bgodfrey,lag(1/5) 
est store model4
ssc install estout
esttab model1 model2 model3 model4, stats(r2 r2_a aic bic) title("BANG SO SANH 4 MO HINH")
display "========== MO HINH 5: LOG - LIN TOI UU =========="
gen ln_number = ln(number)
gen age2 = age^2
regress lprice rating ln_number age age2 i.country_num, robust
vif
display "========== MO HINH 6: QREG =========="
sqreg price rating number age i.country_num, q(.25 .5 .75)
test [q25]rating = [q75]rating
linktest

