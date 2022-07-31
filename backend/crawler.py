""" Entry file for the crawler service. """
import time
import sys
import os
from modules import WebCrawler, Variables, Logger, Database


def crawler_main():
    """ Main crawler function. """
    env_variables = Variables()
    env_variables.init_variables_from_env()
    start_time = time.time()
    my_crawler.get_root_page_links()
    Database.delete_links_found(my_crawler.get_root_page_url())
    end_time = time.time()
    run_time = "{:.2f}".format(end_time - start_time)
    logger.debug(f"[pid:{os.getpid()}] Ended a crawl after {run_time} seconds")


def main():
    """ Initialization function used to determine arguments passed from flask. """
    input_args = sys.argv
    repeat_times = 1
    interval_seconds = 60
    arguments_sum = len(input_args) - 1
    argument_index = 1
    diff_threshold = 1.0
    crawl_url = ''
    try:
        total_start_time = time.time()
        logger.info(
            f"[pid:{os.getpid()}] Crawler started for {repeat_times} itterations on {crawl_url}!")
        while arguments_sum >= argument_index:
            if argument_index == 1:
                repeat_times = int(input_args[argument_index])
            elif argument_index == 2:
                interval_seconds = int(input_args[argument_index])
            elif argument_index == 3:
                diff_threshold = int(input_args[argument_index])
            elif argument_index == 4:
                crawl_url = str(input_args[argument_index])
            argument_index = argument_index + 1
        my_crawler.set_root_page_url(crawl_url)
        my_crawler.set_diff_threshold(diff_threshold/100)
        for index_y in range(repeat_times):
            logger.debug(
                f'[pid:{os.getpid()}] Itteration {index_y+1} / {repeat_times} started')
            crawler_main()
            logger.debug(
                f'[pid:{os.getpid()}] Itteration {index_y+1} / {repeat_times} finished')
            if index_y + 1 < repeat_times:
                time.sleep(int(interval_seconds))
                Database.increment_crawler_step(os.getpid(), crawl_url)
            else:
                Database.update_finished_crawler(
                    os.getpid(), crawl_url, status="Finished")
    except Exception as exc:
        logger.error(f"[pid:{os.getpid()}] Error on crawler itteration, {exc}")
    if os.path.isfile("./archive/temp.html"):
        # Deleting temp file used for calculating diff ratio between archives
        os.remove("./archive/temp.html")
    total_end_time = time.time()
    total_run_time = "{:.2f}".format(total_end_time - total_start_time)
    logger.info(
        f"[pid:{os.getpid()}] Crawler finished {repeat_times} itterations after {total_run_time} seconds!")


if __name__ == "__main__":
    Logger.init_logger()
    logger = Logger.get_logger()
    my_crawler = WebCrawler()
    main()
