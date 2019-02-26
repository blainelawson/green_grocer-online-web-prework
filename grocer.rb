require "pry"

def consolidate_cart(cart)
  consolidated_cart = {}
  items_array = [] 
  
  items_array = cart.map {|items_hash| items_hash.keys}.flatten
  
  items_array.each do |item|
    item_count = items_array.count(item)
    
    cart.each do |items_hash|
      items_hash.each do |key, value|
        
        item_values = {}
          if item == key
            value[:count] = item_count
            item_values = value
            
            consolidated_cart[item] = item_values
            break       #breaks after first instance of item because all values for that item remain the same
          end
        end
    end
  end
    
  consolidated_cart
end

def apply_coupons(cart, coupons)

  couponed_item_count = 0
  
  coupons.each do |coupon_hash|
    couponed_item = {}

    item_name = coupon_hash[:item]
   
    if cart[item_name]  && cart[item_name][:count] >= coupon_hash[:num]

      if cart["#{item_name} W/COUPON"]
          
        cart["#{item_name} W/COUPON"][:count] += 1
      else
        couponed_item["#{item_name} W/COUPON"] = {
                                        price: coupon_hash[:cost],
                                        clearance: cart[item_name][:clearance],
                                        count: 1
                                        }
        cart["#{item_name} W/COUPON"] = couponed_item["#{item_name} W/COUPON"]                                        
      end

      cart[item_name][:count] -= coupon_hash[:num]
    end
  end
  
  cart
end

def apply_clearance(cart)
  
  cart.each do |item, values|
    # binding.pry
    if values[:clearance] == true
      price = (values[:price] * 0.80).round(2)
      cart[item][:price] = price
    end
  end
  
  cart
end

def checkout(cart, coupons)
  apply_coupons(consolidate_cart(cart))
end
