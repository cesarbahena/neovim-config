function square(x) {
  const sqr = x * x;
  return sqr;
}

function hypotenuse(a, b) {
  const sqr_a = square(a);
  const sqr_b = square(b);
  const sqr_c = sqr_a + sqr_b;
  const c = Math.sqrt(sqr_c);
  return c;
}

const a1 = 5;
const sqr_a1 = square(a1);
const a2 = 3;
const sqr_a2 = square(a2);
const c1 = hypotenuse(sqr_a1, sqr_a2);
console.log(a1, a2, c1);
const u = {
  uno: {
    a: 1,
    b: {
      c: 'anera',
    },
  },
};
