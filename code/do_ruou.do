use "C:\Users\Windows\Downloads\Báo cáo kinh tế lượng_Nhóm 1\wine_dataset.dta"
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
estat ovtest
estat hettest
predict resid4, residuals
sktest resid4
swilk resid4
estat dwatson
estat durbin 
estat bgodfrey,lag(1/5) 
est store model4
ssc install estout
esttab model1 model2 model3 model4, stats(r2 r2_a aic bic) title("BANG SO SANH 4 MO HINH")
display "========== MO HINH 5: LOG - LOG TOI UU =========="
gen lrating2 = lrating^2
regress lprice lrating lrating2 lnumber lage i.country_num, vce(robust)
predict resid_final, residuals


