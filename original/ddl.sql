-- Sccsid:     @(#)dss.ddl	2.1.8.1
CREATE TABLE NATION  ( N_NATIONKEY  INTEGER NOT NULL, -- 4
                            N_NAME       CHAR(25) NOT NULL, -- 25
                            N_REGIONKEY  INTEGER NOT NULL, -- 4
                            N_COMMENT    VARCHAR(152)); -- 152

CREATE TABLE REGION  ( R_REGIONKEY  INTEGER NOT NULL, -- 4
                            R_NAME       CHAR(25) NOT NULL, -- 25
                            R_COMMENT    VARCHAR(152)); -- 152

CREATE TABLE PART  ( P_PARTKEY     INTEGER NOT NULL, -- 4
                          P_NAME        VARCHAR(55) NOT NULL, -- 55
                          P_MFGR        CHAR(25) NOT NULL, -- 25
                          P_BRAND       CHAR(10) NOT NULL, -- 10
                          P_TYPE        VARCHAR(25) NOT NULL, -- 22
                          P_SIZE        INTEGER NOT NULL, -- 4
                          P_CONTAINER   CHAR(10) NOT NULL, -- 10
                          P_RETAILPRICE DECIMAL(15,2) NOT NULL, -- 17
                          P_COMMENT     VARCHAR(23) NOT NULL ); -- 23

CREATE TABLE SUPPLIER ( S_SUPPKEY     INTEGER NOT NULL, -- 4
                             S_NAME        CHAR(25) NOT NULL, -- 25
                             S_ADDRESS     VARCHAR(40) NOT NULL, -- 40
                             S_NATIONKEY   INTEGER NOT NULL, -- 4
                             S_PHONE       CHAR(15) NOT NULL, -- 15
                             S_ACCTBAL     DECIMAL(15,2) NOT NULL, -- 17
                             S_COMMENT     VARCHAR(101) NOT NULL); -- 101

CREATE TABLE PARTSUPP ( PS_PARTKEY     INTEGER NOT NULL, -- 4
                             PS_SUPPKEY     INTEGER NOT NULL, -- 4
                             PS_AVAILQTY    INTEGER NOT NULL, -- 4
                             PS_SUPPLYCOST  DECIMAL(15,2)  NOT NULL, -- 17
                             PS_COMMENT     VARCHAR(199) NOT NULL ); -- 199

CREATE TABLE CUSTOMER ( C_CUSTKEY     INTEGER NOT NULL, -- 4
                             C_NAME        VARCHAR(25) NOT NULL, -- 25
                             C_ADDRESS     VARCHAR(40) NOT NULL, -- 40
                             C_NATIONKEY   INTEGER NOT NULL, -- 4
                             C_PHONE       CHAR(15) NOT NULL, -- 15
                             C_ACCTBAL     DECIMAL(15,2)   NOT NULL, -- 17
                             C_MKTSEGMENT  CHAR(10) NOT NULL, -- 10
                             C_COMMENT     VARCHAR(117) NOT NULL); -- 117

CREATE TABLE ORDERS  ( O_ORDERKEY       INTEGER NOT NULL, -- 4
                           O_CUSTKEY        INTEGER NOT NULL, -- 4
                           O_ORDERSTATUS    CHAR(1) NOT NULL, -- 1
                           O_TOTALPRICE     DECIMAL(15,2) NOT NULL, -- 17
                           O_ORDERDATE      DATE NOT NULL, -- 4
                           O_ORDERPRIORITY  CHAR(15) NOT NULL, -- 15 
                           O_CLERK          CHAR(15) NOT NULL, -- 15
                           O_SHIPPRIORITY   INTEGER NOT NULL, -- 4
                           O_COMMENT        VARCHAR(79) NOT NULL); -- 79

CREATE TABLE LINEITEM ( L_ORDERKEY    INTEGER NOT NULL, -- 4
                             L_PARTKEY     INTEGER NOT NULL, -- 4
                             L_SUPPKEY     INTEGER NOT NULL, -- 4
                             L_LINENUMBER  INTEGER NOT NULL, -- 4
                             L_QUANTITY    DECIMAL(15,2) NOT NULL, -- 17
                             L_EXTENDEDPRICE  DECIMAL(15,2) NOT NULL, -- 17
                             L_DISCOUNT    DECIMAL(15,2) NOT NULL, -- 17
                             L_TAX         DECIMAL(15,2) NOT NULL, -- 17
                             L_RETURNFLAG  CHAR(1) NOT NULL, -- 1
                             L_LINESTATUS  CHAR(1) NOT NULL, -- 1
                             L_SHIPDATE    DATE NOT NULL, -- 4
                             L_COMMITDATE  DATE NOT NULL, -- 4
                             L_RECEIPTDATE DATE NOT NULL, -- 4
                             L_SHIPINSTRUCT CHAR(25) NOT NULL, -- 25
                             L_SHIPMODE     CHAR(10) NOT NULL, -- 10
                             L_COMMENT      VARCHAR(44) NOT NULL); -- 44

