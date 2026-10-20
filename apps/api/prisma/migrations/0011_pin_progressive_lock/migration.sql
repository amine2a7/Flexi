-- Payment PIN (securite B5-S01, plan of 2026-10-21): 3 wrong PINs lock it 15 min, then 30, then
-- 60, then until a full sign-in. The attempt is reserved by one UPDATE before the check, so
-- simultaneous requests can never test more than 3 PINs per lock window.
ALTER TABLE employees
  ADD COLUMN pin_lock_level integer NOT NULL DEFAULT 0,
  ADD COLUMN pin_requires_reauth boolean NOT NULL DEFAULT false;
ALTER TABLE employees ADD CONSTRAINT employees_pin_failures_range CHECK (pin_failures BETWEEN 0 AND 3);
ALTER TABLE employees ADD CONSTRAINT employees_pin_lock_level_range CHECK (pin_lock_level >= 0);
