/*Покажите среднюю зарплату сотрудников за каждый год (средняя заработная плата среди тех, кто работал в отчетный период - статистика с начала до 2005 года).*/
SELECT YEAR(hire_date) AS year, AVG(salary) AS average_salary
FROM Employees e
INNER JOIN salaries s ON e.emp_no = s.emp_no
WHERE hire_date <= '2005-01-01'
GROUP BY YEAR(hire_date)
ORDER BY year(hire_date) DESC;

/*Покажите среднюю зарплату сотрудников по каждому отделу. Примечание: принять в
расчет только текущие отделы и текущую заработную плату.*/
 SELECT d.dept_name, AVG(s.salary) AS average_salary
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE de.to_date > curdate() AND s.to_date > curdate()
GROUP BY d.dept_name;

/*3. Покажите среднюю зарплату сотрудников по каждому отделу за каждый год.
Примечание: для средней зарплаты отдела X в году Y нам нужно взять среднее
значение всех зарплат в году Y сотрудников, которые были в отделе X в году Y.*/
SELECT d.dept_name, YEAR(s.to_date) AS year, AVG(s.salary) AS average_salary
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE s.to_date >= '2000-01-01' AND s.to_date <= '2005-12-31'
GROUP BY d.dept_name, YEAR(s.to_date);

/*4. Покажите для каждого года самый крупный отдел (по количеству сотрудников) в этом
году и его среднюю зарплату.*/

SELECT
  YEAR(e2.hire_date) AS year,
  d.dept_name AS largest_department,
  AVG(s.salary) AS average_salary
FROM
  employees e2
  INNER JOIN dept_emp de ON e2.emp_no = de.emp_no
  INNER JOIN departments d ON de.dept_no = d.dept_no
  INNER JOIN salaries s ON e2.emp_no = s.emp_no
WHERE
  (de.from_date <= s.from_date AND de.to_date >= s.to_date)
  AND e2.hire_date IN (
    SELECT
      MAX(e3.hire_date)
    FROM
      employees e3
      INNER JOIN dept_emp de3 ON e3.emp_no = de3.emp_no
    GROUP BY
      YEAR(e3.hire_date)
  )
GROUP BY
  YEAR(e2.hire_date), d.dept_name;

/*5. Покажите подробную информацию о менеджере, который дольше всех исполняет свои
обязанности на данный момент.*/ 

SELECT 
  dm.emp_no, CONCAT(e.first_name, ' ', e.last_name) AS manager_name, e.hire_date AS manager_hire_date,
  DATEDIFF(CURDATE(), dm.from_date)/362 AS duration_years
FROM
  dept_manager dm
  INNER JOIN employees e ON dm.emp_no = e.emp_no
WHERE dm.to_date > now() ORDER BY duration_years DESC LIMIT 1;

/*6. Покажите топ-10 нынешних сотрудников компании с наибольшей разницей между их
зарплатой и текущей средней зарплатой в их отделе.*/

SELECT e.emp_no, e.first_name, e.last_name, d.dept_name, s.salary, avg_salary.avg_department_salary, s.salary - avg_salary.avg_department_salary AS salary_difference
FROM employees AS e
JOIN salaries AS s ON e.emp_no = s.emp_no
JOIN dept_emp AS de ON e.emp_no = de.emp_no
JOIN departments AS d ON de.dept_no = d.dept_no
JOIN (
    SELECT de.dept_no, AVG(s.salary) AS avg_department_salary
    FROM dept_emp AS de
    JOIN salaries AS s ON de.emp_no = s.emp_no
    WHERE s.to_date >= CURRENT_DATE AND de.to_date >= CURRENT_DATE
    GROUP BY de.dept_no
) AS avg_salary ON d.dept_no = avg_salary.dept_no
WHERE s.to_date >= CURRENT_DATE AND de.to_date >= CURRENT_DATE
ORDER BY salary_difference DESC
LIMIT 10;

/*7. Из-за кризиса на одно подразделение на своевременную выплату зарплаты выделяется
всего 500 тысяч долларов. Правление решило, что низкооплачиваемые сотрудники
будут первыми получать зарплату. Показать список всех сотрудников, которые будут
вовремя получать зарплату (обратите внимание, что мы должны платить зарплату за
один месяц, но в базе данных мы храним годовые суммы)*/

SELECT
  d.dept_no, d.dept_name, e.emp_no, e.first_name, e.last_name, s.salary
FROM
  departments d
  INNER JOIN (
    SELECT
      de.dept_no,
      SUM(s.salary) AS total_salary
    FROM
      dept_emp de
      INNER JOIN salaries s ON de.emp_no = s.emp_no
    GROUP BY
      de.dept_no
  ) dept_salary ON d.dept_no = dept_salary.dept_no
  INNER JOIN dept_emp de ON d.dept_no = de.dept_no
  INNER JOIN employees e ON de.emp_no = e.emp_no
  INNER JOIN salaries s ON e.emp_no = s.emp_no
WHERE
  s.salary IN (
    SELECT
      MIN(s2.salary)
    FROM
      dept_emp de2
      INNER JOIN salaries s2 ON de2.emp_no = s2.emp_no
    WHERE
      de2.dept_no = d.dept_no
    GROUP BY
      de2.dept_no
    HAVING
      SUM(s2.salary) <= 500000
  )
ORDER BY
  d.dept_no, s.salary;