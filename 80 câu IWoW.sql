-- Liệt kê tất cả các vendors và số lượng shops thuộc về mỗi vendor.

select v.name as 'Tên cơ sở', count(v.name) as 'Số lượng cơ sở'
from [test_iwow3].[vendors] v
join [test_iwow3].[shops] s on s.vendor_id = v.id
group by v.name


-- Tìm các users không có vendors và shops tương ứng.
select full_name as 'Tên khách hàng', phone as 'Số điện thoại'
from [test_iwow3].[users]
where role  <> 'Vendor'

-- Liệt kê tất cả các users và danh sách các services đã đặt trong các bookings của họ.
select u.full_name as 'Họ và tên khách hàng', s.name as 'Dịch vụ đã đặt'
from [test_iwow3].[users] u
join [test_iwow3].[bookings] b on u.id = b.customer_id
join [test_iwow3].[booking_services] bs on bs.booking_id = b.id
join [test_iwow3].[services] s on s.id = bs.service_id


-- Tìm users có số lượng bookings nhiều nhất.
select u.full_name as 'Tên khách hàng', count(u.full_name) as 'Lượt booking'
from [test_iwow3].[users] u
join [test_iwow3].[bookings] b on u.id = b.customer_id
group by u.full_name
order by count(u.full_name) desc

-- Tính tổng số lượng bookings theo từng ngày.
select convert(date, b.time) as 'Ngày',
		count(*) as 'Tổng số lượng booking'
from [test_iwow3].[bookings] b
group by convert(date, b.time)
order by convert(date, b.time)

-- Tìm tất cả các bookings có số lượng services lớn hơn 5.
select convert(date, b.time) as 'Ngày',
	count(*) as  'Tổng số lượng booking'
from [test_iwow3].[bookings] b
group by convert(date, b.time)
order by convert(date, b.time)

select *
from [test_iwow3].[bookings]
where (
	select count(*)
	from [test_iwow3].[booking_services]
	where [test_iwow3].[booking_services].booking_id = [test_iwow3].[bookings].id)
>5

-- Tìm tất cả số lượng booking > 5
select b.* 
from [test_iwow3].[bookings] b
join (
select booking_id, count (*) as service_acount
from [test_iwow3].[booking_services]
group by booking_id
having count(*) > 5
) bs 
on b.id = bs.booking_id

select b.* 
from [test_iwow3].[bookings] b
where b.id in (
	select booking_id
	from [test_iwow3].[booking_services]
	group by booking_id
	having count(*) > 5)

-- Liệt kê tất cả các users và số lượng bookings của mỗi user.
select u.full_name
from [test_iwow3].[users] u
where u.id in (
	select b.id , count(*) 
	from [test_iwow3].[bookings] b
	group by b.id)

-- Tìm các bookings mà số lượng services được đặt là lớn nhất.

select s.name as 'Tên dịch vụ', count(*) as 'Số lượng đặt'
from [test_iwow3].[bookings] b 
join [test_iwow3].[booking_services] bs on b.id = bs.booking_id
join [test_iwow3].[services] s on bs.service_id = s.id
group by s.name
order by count(*) desc

SELECT b.id AS booking_id, COUNT(bs.service_id) AS service_count
FROM [test_iwow3].[bookings] b
JOIN [test_iwow3].[booking_services] bs ON b.id = bs.booking_id
GROUP BY b.id
HAVING COUNT(bs.service_id) = (
    SELECT MAX(service_count)
    FROM (
        SELECT COUNT(service_id) AS service_count
        FROM [test_iwow3].[booking_services]
        GROUP BY booking_id
    ) AS counts
)

-- Liệt kê tất cả các categories và số lượng services thuộc về mỗi category.
select sc.category_id,c.name,count(*) as quantity
from [test_iwow3].[service_categories] sc
join [test_iwow3].[services] s on s.id = sc.service_id
join [test_iwow3].[categories] c on sc.category_id = c.id
group by sc.category_id, c.name
order by sc.category_id

-- Tìm tất cả các vendors và số lượng bookings của mỗi vendor.
select v.name, count(v.name)
from [test_iwow3].[vendors] v 
join [test_iwow3].[shops] s on s.vendor_id = v.id
join [test_iwow3].[bookings] b on b.shop_id = s.id
group by v.name

-- Tìm tất cả các shops có địa chỉ trùng nhau.
select s.address, count(*) as duplicated_address
from [test_iwow3].[shops] s
group by s.address
having count(*) > 1

-- Tính tổng số lượng bookings theo từng tháng và sắp xếp kết quả theo thứ tự giảm dần.

select month(b.time) as 'Tháng' , count(*)  as 'Số lượng booking'
from [test_iwow3].[bookings] b
group by month(b.time)
having count(*) > 0		
order by count(*) desc

-- Tìm tất cả các services và số lượng bookings của mỗi service theo thứ tự giảm dần
select bs.service_id, s.name as 'Dịch vụ', count(*) as 'Số lượng dịch vụ'
from [test_iwow3].[services] s
join [test_iwow3].[booking_services] bs on bs.service_id = s.id
group by bs.service_id, s.name
order by count(*) desc

-- Tìm tất cả các users không có bất kỳ bookings nào.

select u.id, b.customer_id
from [test_iwow3].[users] u
left join [test_iwow3].[bookings] b on b.customer_id = u.id 
group by u.id, b.customer_id
having b.customer_id = 0

select u.id, b.customer_id
from [test_iwow3].[users] u 
left join [test_iwow3].[bookings] b on u.id = b.customer_id
where b.booking_id is null

-- Tìm tất cả các bookings và số lượng services của mỗi booking.
select ser.name as 'Tên dịch vụ', count(*) as 'Số lượng'
from [test_iwow3].[bookings] b
join [test_iwow3].[booking_services] bs on b.id = bs.booking_id
join [test_iwow3].[services] ser on bs.service_id = ser.id
group by ser.name
order by count(*) desc


/*

Tìm các vendors không có bất kỳ services nào.
Tìm tất cả các shops và số lượng bookings của mỗi shop.
Tính tổng số lượng services thuộc về mỗi category và sắp xếp kết quả theo thứ tự tăng dần.
Tìm tất cả các vendors và số lượng services của mỗi vendor.
Tìm tất cả các bookings có số lượng services nhỏ hơn 3.
Tìm tất cả các shops và danh sách các services thuộc về mỗi shop.
Tìm các vendors không có bất kỳ shops hoạt động và không có services tương ứng.
Tính tổng số lượng shops thuộc về mỗi vendor và sắp xếp kết quả theo thứ tự giảm dần.
Liệt kê tất cả các users và số lượng services đã đặt trong các bookings của họ, sắp xếp kết quả theo thứ tự giảm dần.
Tìm các users có số lượng services đã đặt nhiều nhất.
Tìm tất cả các categories không được sử dụng trong bất kỳ services nào và không có bất kỳ shops hoạt động tương ứng.
Tính tổng số lượng bookings theo từng năm và sắp xếp kết quả theo thứ tự giảm dần.
Tìm tất cả các bookings có số lượng services lớn hơn 10.
Tìm tất cả các vendors không có bất kỳ shops nào.
Liệt kê tất cả các users và số lượng bookings của mỗi user, sắp xếp kết quả theo thứ tự giảm dần.
Tìm các services không thuộc vào bất kỳ category nào và không được đặt trong bất kỳ bookings nào.
Tìm các bookings mà số lượng services được đặt là nhỏ nhất.
Liệt kê tất cả các categories và số lượng services thuộc về mỗi category, sắp xếp kết quả theo thứ tự giảm dần.
Tìm tất cả các vendors và số lượng bookings của mỗi vendor, sắp xếp kết quả theo thứ tự giảm dần.
Tìm tất cả các shops có địa chỉ trùng nhau và không thuộc vào bất kỳ vendors nào.
Tính tổng số lượng bookings theo từng ngày và sắp xếp kết quả theo thứ tự tăng dần.
Tìm tất cả các services và số lượng bookings của mỗi service, sắp xếp kết quả theo thứ tự giảm dần.
Tìm tất cả các users không có bất kỳ bookings nào và không có bất kỳ vendors tương ứng.
Liệt kê tất cả các vendors và danh sách các services thuộc về mỗi vendor, sắp xếp kết quả theo thứ tự giảm dần.
Tìm các shops có tên trùng nhau nhưng thuộc về các vendors khác nhau và có số lượng bookings lớn hơn 5.
Tìm tất cả các bookings và số lượng services của mỗi booking, sắp xếp kết quả theo thứ tự giảm dần.
Tìm các vendors không có bất kỳ services nào và không có bất kỳ shops tương ứng.
Tìm tất cả các shops và số lượng bookings của mỗi shop, sắp xếp kết quả theo thứ tự giảm dần.
Tính tổng số lượng services thuộc về mỗi category và sắp xếp kết quả theo thứ tự giảm dần.
Tìm tất cả các vendors và số lượng services của mỗi vendor, sắp xếp kết quả theo thứ tự tăng dần.
Tìm tất cả các bookings có số lượng services nhỏ hơn 3 và không có bất kỳ vendors nào.
Tìm tất cả các shops và danh sách các services thuộc về mỗi shop, sắp xếp kết quả theo thứ tự giảm dần.
Tìm các vendors không có bất kỳ shops hoạt động và không có bất kỳ services tương ứng.
Tính tổng số lượng bookings theo từng năm và sắp xếp kết quả theo thứ tự tăng dần, chỉ hiển thị năm có tổng số lượng bookings lớn hơn 100.
Tìm tất cả các bookings có số lượng services lớn hơn 20 và có tổng số lượng services chia hết cho 5.
Tìm tất cả các vendors không có bất kỳ shops nào và không có bất kỳ bookings tương ứng.
Liệt kê tất cả các users và số lượng bookings của mỗi user, sắp xếp kết quả theo thứ tự tăng dần, chỉ hiển thị users có số lượng bookings nhiều hơn 5.
Tìm các services không thuộc vào bất kỳ category nào và không được đặt trong bất kỳ bookings nào, và không có bất kỳ vendors tương ứng.
Tìm các bookings mà số lượng services được đặt là nhỏ nhất và có tổng số lượng services chia hết cho 3.
Liệt kê tất cả các categories và số lượng services thuộc về mỗi category, sắp xếp kết quả theo thứ tự tăng dần, chỉ hiển thị categories có số lượng services lớn hơn 10.
Tìm tất cả các vendors và số lượng bookings của mỗi vendor, sắp xếp kết quả theo thứ tự tăng dần, chỉ hiển thị vendors có số lượng bookings lớn hơn 2.
Tìm tất cả các shops có địa chỉ trùng nhau và không thuộc vào bất kỳ vendors nào, và có số lượng bookings nhỏ hơn 3.
Tính tổng số lượng bookings theo từng tháng và sắp xếp kết quả theo thứ tự giảm dần, chỉ hiển thị tháng có tổng số lượng bookings lớn hơn 50.
Tìm tất cả các services và số lượng bookings của mỗi service, sắp xếp kết quả theo thứ tự giảm dần, chỉ hiển thị services có số lượng bookings lớn hơn 5.
Tìm tất cả các users không có bất kỳ bookings nào và không có bất kỳ vendors tương ứng, và có số lượng services lớn hơn 2.
Liệt kê tất cả các vendors và danh sách các services thuộc về mỗi vendor, sắp xếp kết quả theo thứ tự tăng dần, chỉ hiển thị vendors có số lượng services lớn hơn 10.
Tìm các shops có tên trùng nhau nhưng thuộc về các vendors khác nhau, và có số lượng bookings lớn hơn 5 và số lượng services nhỏ hơn 10.
Tìm tất cả các bookings và số lượng services của mỗi booking, sắp xếp kết quả theo thứ tự giảm dần, chỉ hiển thị bookings có số lượng services lớn hơn 3.
Tìm các vendors không có bất kỳ services nào và không có bất kỳ shops tương ứng, và có số lượng bookings nhỏ hơn 2.
Tìm tất cả các shops và số lượng bookings của mỗi shop, sắp xếp kết quả theo thứ tự tăng dần, chỉ hiển thị shops có số lượng bookings lớn hơn 1.
Tính tổng số lượng services thuộc về mỗi category và sắp xếp kết quả theo thứ tự tăng dần, chỉ hiển thị categories có số lượng services lớn hơn 5.
Tìm tất cả các vendors và số lượng services của mỗi vendor, sắp xếp kết quả theo thứ tự giảm dần, chỉ hiển thị vendors có số lượng services lớn hơn 20.
Tìm tất cả các bookings có số lượng services nhỏ hơn 3 và có tổng số lượng services chia hết cho 5.
Tìm tất cả các shops và danh sách các services thuộc về mỗi shop, sắp xếp kết quả theo thứ tự tăng dần, chỉ hiển thị shops có số lượng services lớn hơn 10.
Tìm các vendors không có bất kỳ shops hoạt động và không có bất kỳ services tương ứng, và có số lượng bookings nhỏ hơn 2.
Tính tổng số lượng bookings theo từng năm và sắp xếp kết quả theo thứ tự tăng dần, chỉ hiển thị năm có tổng số lượng bookings lớn hơn 200.
Tìm tất cả các bookings có số lượng services lớn hơn 20 và có tổng số lượng services chia hết cho 10.
Tìm tất cả các vendors không có bất kỳ shops nào và không có bất kỳ bookings tương ứng, và có số lượng services lớn hơn 5.
Liệt kê tất cả các users và số lượng bookings của mỗi user, sắp xếp kết quả theo thứ tự tăng dần, chỉ hiển thị users có số lượng bookings lớn hơn 10.