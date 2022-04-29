
def change_header(file_path):
    file = open(file_path, "rb")
    file_dump = file.read()
    file.close()

    file_dump = file_dump.replace(b'\x84\x00\x00\x00', b'\x28\xbc\x11\x92', 1)

    new_file = open(file_path, "wb")

    new_file.write(file_dump)

    new_file.close()

change_header("wwise/Init.wwise_bank")
change_header("wwise/pan_hits.wwise_bank")

