def find_item_by_name_in_collection(name, collection)
  count = 0
  while count < collection.length
    if collection[count][:item] == name
      return collection[count]
    else
      nil
    end
    count += 1
  end
end

def consolidate_cart(cart)
  count = 0
  result = []
  while count < cart.length
    item = find_item_by_name_in_collection(cart[count][:item], result)
    if !item 
      cart[count][:count] = 1
      result.push(cart[count])
    else 
      if item[:count] 
        item[:count] = item[:count] + 1
      else
        item[:count] = 1
      end
    end
    count += 1
  end
  puts result
  result
end


def apply_coupons(cart, coupons)
  coupon_index = 0
  while coupon_index < coupons.length
    cur_coup = coupons[coupon_index]
    applicable_item = find_item_by_name_in_collection(cur_coup[:item], cart)
    couponed_item = find_item_by_name_in_collection("#{cur_coup[:item]} W/COUPON", cart)
    if applicable_item && applicable_item[:count] >= cur_coup[:num]
      if couponed_item
        couponed_item[:count] += cur_coup[:num]
        applicable_item -= cur_coup[:num]
      else
        couponed_item = {
        :item => "#{cur_coup[:item]} W/COUPON",
        :price => cur_coup[:cost] / cur_coup[:num],
        :clearance => applicable_item[:clearance],
        :count => cur_coup[:num]
      }
      cart << couponed_item
      applicable_item[:count] -= cur_coup[:num]
      end
    end
    coupon_index += 1
  end
  puts cart
  cart
end

def apply_clearance(cart)
  count = 0
  while count < cart.length
    if cart[count][:clearance]
      cart[count][:price] = cart[count][:price] * 100
      cart[count][:price] *= 0.8
      cart[count][:price] = cart[count][:price].ceil(2) / 100
    end
    count += 1
  end
    cart
end




def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)

  count = 0
  total = 0
  while count < cart.length
    line_total = cart[count][:price] * cart[count][:count]
    total += line_total
    count += 1
  end

  if total > 100.00
    total *= 0.9
  end

  total

end