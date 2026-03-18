// app.js — Core Application Logic
 
 // Sample product data (replace with API call when backend is ready)
 const products = [
   { id: 1, name: 'Wireless Headphones', category: 'Electronics',
     price: 1299, stock: 50, image: 'img/headphones.jpg' },
   { id: 2, name: 'Running Shoes', category: 'Footwear',
     price: 2499, stock: 30, image: 'img/shoes.jpg' },
   { id: 3, name: 'Laptop Backpack', category: 'Accessories',
     price: 799, stock: 100, image: 'img/backpack.jpg' },
   { id: 4, name: 'Smart Watch', category: 'Electronics',
     price: 3499, stock: 25, image: 'img/watch.jpg' },
 ];
 
 // Render products to DOM
 function renderProducts(items) {
   const grid = document.getElementById('product-grid');
   if (!grid) return;
   grid.innerHTML = items.map(p => `
     <div class='product-card'>
       <img src='${p.image}' alt='${p.name}' onerror="this.src='img/default.jpg'">
       <div class='product-info'>
         <h3>${p.name}</h3>
         <span class='category'>${p.category}</span>
         <p class='price'>&#8377;${p.price.toLocaleString('en-IN')}</p>
         <button class='btn-primary' onclick='addToCart(${p.id})'>
           Add to Cart
         </button>
       </div>
     </div>
   `).join('');
 }
 
 // Cart operations
 function getCart() {
   return JSON.parse(localStorage.getItem('cart') || '[]');
 }
 
 function addToCart(productId) {
   const cart = getCart();
   const existing = cart.find(item => item.id === productId);
   if (existing) {
     existing.qty += 1;
   } else {
     const product = products.find(p => p.id === productId);
     cart.push({ id: productId, name: product.name,
                 price: product.price, qty: 1 });
   }
   localStorage.setItem('cart', JSON.stringify(cart));
   updateCartCount();
   showNotification(`${products.find(p=>p.id===productId).name} added to cart!`);
 }
 
 function updateCartCount() {
   const cart = getCart();
   const total = cart.reduce((sum, item) => sum + item.qty, 0);
   const el = document.getElementById('cart-count');
   if (el) el.textContent = total;
 }
 
 function searchProducts() {
   const query = document.getElementById('search-bar').value.toLowerCase();
   const filtered = products.filter(p =>
     p.name.toLowerCase().includes(query) ||
     p.category.toLowerCase().includes(query)
   );
   renderProducts(filtered);
 }
 
 function showNotification(msg) {
   const div = document.createElement('div');
   div.className = 'notification';
   div.textContent = msg;
   document.body.appendChild(div);
   setTimeout(() => div.remove(), 2500);
 }
 
 // Initialise on page load
 document.addEventListener('DOMContentLoaded', () => {
   renderProducts(products);
   updateCartCount();
});
