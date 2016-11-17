CREATE TABLE `jrj_xwlb_szzs_dayk` (
  `data_time` date NOT NULL DEFAULT '0000-00-00',
  `open_value` decimal(17,4) NOT NULL DEFAULT '0.0000',
  `close_value` decimal(17,4) NOT NULL DEFAULT '0.0000',
  `high_value` decimal(17,4) NOT NULL DEFAULT '0.0000',
  `low_value` decimal(17,4) NOT NULL DEFAULT '0.0000',
  `cnt_value` decimal(17,4) NOT NULL DEFAULT '0.0000',
  `range_value` decimal(17,4) NOT NULL DEFAULT '0.0000',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`data_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `jrj_xwlb_word_daily` (
  `data_time` date NOT NULL DEFAULT '0000-00-00',
  `cn_word` varchar(1024) NOT NULL DEFAULT '',
  `cn_word_cnt` int(11) NOT NULL DEFAULT '0',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY `key_jrj_xwlb_word_daily_cn_word` (`cn_word`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `jrj_xwlb_szzs_score` (
  `data_time` date NOT NULL DEFAULT '0000-00-00',
  `score` decimal(17,4) NOT NULL DEFAULT '0.0000',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`data_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
