-- sales.csv
order_id,product,region,quantity,revenue
1,Laptop,North,1,80000
2,Mouse,North,2,3000
3,Laptop,South,1,80000
4,Keyboard,West,3,9000
5,Monitor,North,2,40000


-- Queries:

SELECT *
FROM OPENROWSET(
    BULK 'https://<storage-account>.dfs.core.windows.net/<container_name>/sales.csv',
    FORMAT = 'CSV',
    PARSER_VERSION = '2.0',
    HEADER_ROW = TRUE
) AS sales;


-- Analytical Query:

SELECT
    region,
    SUM(revenue) AS total_revenue
FROM OPENROWSET(
    BULK 'https://synapsedemoaccountt.blob.core.windows.net/synapse-data/sales.csv',
    FORMAT = 'CSV',
    PARSER_VERSION = '2.0',
    HEADER_ROW = TRUE
) AS sales
GROUP BY region
ORDER BY total_revenue DESC;


